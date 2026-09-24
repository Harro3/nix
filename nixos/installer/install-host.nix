# `install-host <hostname>` -- run from the installer ISO once /mnt is mounted.
#
# Replaces steps 2 through 10 of the old manual guide: it scaffolds the host
# config, detects the hardware, seeds the age key so sops secrets decrypt on the
# very first boot, and runs nixos-install against this flake.
{
  perSystem =
    { pkgs, ... }:
    {
      packages.install-host = pkgs.writeShellApplication {
        name = "install-host";
        runtimeInputs = [
          pkgs.coreutils
          pkgs.gnused
          pkgs.nix
          pkgs.nixos-install-tools
          pkgs.util-linux
        ];
        text = ''
          # Baked into the ISO so nothing has to be cloned from GitHub.
          CONFIG_SRC="''${CONFIG_SRC:-/etc/nix-config}"
          SECRETS_SRC="''${SECRETS_SRC:-/etc/nix-secrets}"
          # Writable copies: the baked ones are read-only store paths.
          WORK="''${WORK:-/root/nix}"
          SECRETS="''${SECRETS:-/root/nix-secrets}"

          usage() {
            cat >&2 <<'EOF'
          usage: install-host [--keep-hardware] <hostname>

          Run this from the installer ISO, after you have partitioned the disk
          and mounted the target root on /mnt (and the ESP on /mnt/boot).

          Run it twice for a brand new host: the first run writes the config for
          you to review, the second one installs it.

          For a host that already exists in the repo it installs straight away
          and regenerates the hardware config from what you mounted, keeping a
          .bak of whatever it replaced. Pass --keep-hardware to reinstall
          without touching it.
          EOF
            exit 1
          }

          keep_hardware=0
          positional=()
          while [ $# -gt 0 ]; do
            case "$1" in
              --keep-hardware) keep_hardware=1; shift ;;
              -h | --help) usage ;;
              -*) echo "unknown option: $1" >&2; usage ;;
              *) positional+=("$1"); shift ;;
            esac
          done
          set -- "''${positional[@]+"''${positional[@]}"}"

          [ $# -ge 1 ] || usage
          host="$1"

          die() { echo "error: $*" >&2; exit 1; }

          [ "$(id -u)" -eq 0 ] || die "run this as root"

          # --- writable copy of the baked-in config -------------------------
          if [ ! -d "$WORK" ]; then
            [ -d "$CONFIG_SRC" ] || die "no config at $CONFIG_SRC (is this the installer ISO?)"
            cp -r --no-preserve=mode,ownership "$CONFIG_SRC" "$WORK"
          fi
          if [ ! -d "$SECRETS" ]; then
            [ -d "$SECRETS_SRC" ] || die "no secrets at $SECRETS_SRC"
            cp -r --no-preserve=mode,ownership "$SECRETS_SRC" "$SECRETS"
          fi
          cd "$WORK"

          # The locked `secrets` input is a git+ssh URL that would demand a
          # GitHub key. Repoint it at the copy the ISO already carries.
          if ! grep -q "$SECRETS" flake.lock 2>/dev/null; then
            nix flake lock --override-input secrets "path:$SECRETS" \
              --extra-experimental-features 'nix-command flakes'
          fi

          hostdir="nixos/hosts/$host"

          # --- first run: scaffold the host config --------------------------
          if [ ! -d "$hostdir" ]; then
            cp -r --no-preserve=mode,ownership nixos/hosts/_template "$hostdir"
            sed -i "s/HOSTNAME/$host/g; s/MODULE/''${host^}/g" "$hostdir"/*.nix
            cat >&2 <<EOF

          Created $WORK/$hostdir from the template.

          Edit $WORK/$hostdir/configuration.nix to pick the modules you want,
          then run 'install-host $host' again to install.
          EOF
            exit 0
          fi

          # --- checks --------------------------------------------------------
          mountpoint -q /mnt || die "/mnt is not a mountpoint -- mount the target root first"
          mountpoint -q /mnt/boot || die "/mnt/boot is not a mountpoint -- mount the ESP first"

          # --- hardware detection --------------------------------------------
          # Reads the real filesystems/LUKS mapping from what you mounted, so
          # there is nothing to copy by hand afterwards.
          hw="$hostdir/_generated/hardware-configuration.nix"
          wrapper="$hostdir/hardware.nix"

          if [ "$keep_hardware" -eq 1 ]; then
            [ -f "$hw" ] || die "--keep-hardware given but $hw does not exist"
            echo "--keep-hardware: leaving $hw untouched" >&2
          else
            mkdir -p "$hostdir/_generated"
            if [ -f "$hw" ]; then
              cp "$hw" "$hw.bak"
              echo "Previous hardware config kept at $hw.bak" >&2
            fi
            nixos-generate-config --root /mnt --show-hardware-config > "$hw"
            echo "Wrote $hw" >&2
          fi

          # A generated file only takes effect if hardware.nix imports it.
          # Hosts predating this layout inline the hardware config instead,
          # which would silently shadow what we just detected and install the
          # old disk UUIDs. Convert them, keeping the original.
          if ! grep -q '_generated/hardware-configuration.nix' "$wrapper" 2>/dev/null; then
            # Take the module name from configuration.nix rather than guessing
            # from the hostname -- e.g. `wsl` uses `hostWSL`, not `hostWsl`.
            module="$(sed -n 's/.*flake\.nixosModules\.\(host[A-Za-z0-9_]*\).*/\1/p' \
              "$hostdir/configuration.nix" | head -1)"
            [ -n "$module" ] || die "cannot find the module name in $hostdir/configuration.nix"

            if [ -f "$wrapper" ]; then
              cp "$wrapper" "$wrapper.bak"
              echo "Inline hardware config kept at $wrapper.bak" >&2
            fi
            printf '%s\n' \
              "{" \
              "  flake.nixosModules.$module = import ./_generated/hardware-configuration.nix;" \
              "}" > "$wrapper"
            echo "Converted $wrapper to import _generated/ (was inline)" >&2
          fi

          # --- seed the age key ----------------------------------------------
          # sops decrypts the user's password during activation, before any home
          # directory exists, so the key has to be in place before first boot.
          user="$(nix eval --raw ".#nixosConfigurations.$host.config.preferences.user.name" \
            --extra-experimental-features 'nix-command flakes')"

          agedir="/mnt/home/$user/.config/sops/age"
          if [ -f "$agedir/keys.txt" ]; then
            echo "Age key already present at $agedir/keys.txt, keeping it." >&2
          else
            echo >&2
            echo "Paste the age private key for '$user' (input hidden), then press Enter:" >&2
            read -rs agekey
            echo >&2
            [ -n "$agekey" ] || die "no age key given -- '$user' would have no password on first boot"
            mkdir -p "$agedir"
            printf '%s\n' "$agekey" > "$agedir/keys.txt"
            chmod 600 "$agedir/keys.txt"
            unset agekey
            echo "Age key written to $agedir/keys.txt" >&2
          fi

          # --- stash the host config -------------------------------------------
          # ~/nix becomes a fresh clone on first boot (see the clone-repos
          # module), and that clone will not contain this brand new host yet.
          # Leave it somewhere the first boot can pick it up.
          stash="/mnt/home/$user/.host-config"
          rm -rf "$stash"
          mkdir -p "$stash"
          cp -r "$hostdir/." "$stash/"
          echo "Stashed the host config in ~/.host-config" >&2

          # --- install ---------------------------------------------------------
          nixos-install --flake ".#$host" --no-channel-copy

          cat >&2 <<EOF

          Installed '$host'. Reboot -- on first boot the clone-repos service
          pulls ~/nix and ~/nix-secrets using the SSH key sops installs.

          Then commit this host into the real repo:

            cp -r ~/.host-config ~/nix/nixos/hosts/$host
            cd ~/nix && git add nixos/hosts/$host && git commit -m "add $host"
          EOF
        '';
      };
    };
}
