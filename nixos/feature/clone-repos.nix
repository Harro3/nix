# Clone the config repos into $HOME on first boot.
#
# sops installs the SSH key as part of activation (~/.ssh/id_ed25519 is a
# symlink into /run/secrets), which happens before multi-user.target -- so by
# the time this service runs the key is already usable and no manual cloning
# is needed after a fresh install.
{
  flake.nixosModules.clone-repos =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      user = config.preferences.user.name;
      home = "/home/${user}";
      cfg = config.preferences.repos;
    in
    {
      options.preferences.repos = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Clone the repos listed in `preferences.repos.clones` on boot.";
        };

        clones = lib.mkOption {
          type = lib.types.attrsOf lib.types.str;
          default = {
            nix = "git@github.com:Harro3/nix.git";
            nix-secrets = "git@github.com:Harro3/nix-secrets.git";
          };
          description = ''
            Directory name under the user's home, mapped to the git remote to
            clone into it. Existing directories are left alone, so a config
            copied over during install is never clobbered.
          '';
        };
      };

      config = lib.mkIf cfg.enable {
        # `install-host` leaves the freshly generated host config here, because
        # ~/nix is about to become a clean clone that does not contain it yet.
        # It is written as root before the user exists, so fix it up here.
        systemd.tmpfiles.rules = [
          "Z ${home}/.host-config 0700 ${user} ${config.users.users.${user}.group} -"
        ];

        systemd.services.clone-repos = {
          description = "Clone config repositories into ${home}";
          wantedBy = [ "multi-user.target" ];
          wants = [ "network-online.target" ];
          after = [ "network-online.target" ];

          path = [
            pkgs.git
            pkgs.openssh
          ];

          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            User = user;
            Group = config.users.users.${user}.group;
            WorkingDirectory = home;
          };

          environment.HOME = home;

          script = ''
            set -u

            key="${home}/.ssh/id_ed25519"
            if [ ! -r "$key" ]; then
              echo "no readable key at $key -- sops has not provisioned it, skipping" >&2
              exit 0
            fi

            # These repos are only ever reached over SSH, and the host key is
            # not known on a fresh install. accept-new trusts it on first
            # contact but still refuses if a known key ever changes.
            export GIT_SSH_COMMAND="ssh -i $key -o StrictHostKeyChecking=accept-new"

            ${lib.concatStringsSep "\n" (
              lib.mapAttrsToList (name: url: ''
                dest="${home}/${name}"
                if [ -e "$dest" ]; then
                  echo "$dest already exists, leaving it alone"
                else
                  echo "cloning ${url} -> $dest"
                  git clone "${url}" "$dest" || echo "failed to clone ${url}" >&2
                fi
              '') cfg.clones
            )}
          '';
        };
      };
    };
}
