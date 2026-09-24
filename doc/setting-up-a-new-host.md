# Setting up a new host

Boot the custom ISO, partition, run one command twice, reboot.

The ISO is built from this flake, so it already carries the config and the
(encrypted) secrets. Nothing is cloned from GitHub during the install, which
means **no throwaway SSH key and no browser round-trip**.

```
on an existing host          on the new machine
------------------           ------------------
nix build .#installer-iso
dd -> USB stick        --->  boot it
                             partition + mount        (step 2)
                             install-host <name>      (step 3, scaffolds)
                             edit configuration.nix
                             install-host <name>      (step 3, installs)
                             reboot
```

## 1. Build and flash the installer ISO

On a machine that already runs this config:

```sh
nix build .#installer-iso
sudo dd if=result/iso/*.iso of=/dev/sdX bs=4M status=progress conv=fsync
```

Rebuild the ISO when you change the config or rotate a secret -- it pins both at
build time.

The ISO boots straight to a root shell with `install-host` on `$PATH`, sshd
running, and your public key already authorised, so you can also just
`ssh root@<ip>` from another machine and paste commands instead of typing on the
new laptop's keyboard.

## 2. Partition and mount

This is the one manual part. Find the disk first:

```sh
lsblk
```

Everything below assumes `/dev/nvme0n1` -- **change it, and note that these
commands destroy the disk**.

### Recipe A -- LUKS + ext4 (what `alae` and `legion` run)

```sh
DISK=/dev/nvme0n1

# GPT: 1G ESP, 8G swap, rest for the encrypted root
sgdisk --zap-all "$DISK"
sgdisk -n1:0:+1G   -t1:ef00 -c1:ESP   "$DISK"
sgdisk -n2:0:+8G   -t2:8200 -c2:swap  "$DISK"
sgdisk -n3:0:0     -t3:8300 -c3:root  "$DISK"
partprobe "$DISK"

# NVMe partitions are p1/p2/p3; on SATA they are 1/2/3
P="${DISK}p"

# Encrypted root
cryptsetup luksFormat "${P}3"
cryptsetup open "${P}3" cryptroot
mkfs.ext4 -L nixos /dev/mapper/cryptroot

mkfs.fat -F32 -n BOOT "${P}1"
mkswap -L swap "${P}2"

# Mount exactly as the installed system will
mount /dev/mapper/cryptroot /mnt
mkdir -p /mnt/boot
mount -o umask=0077 "${P}1" /mnt/boot
swapon "${P}2"
```

The mapper name you pick (`cryptroot` above) is what ends up in the generated
hardware config, so it is cosmetic -- pick anything.

> **Note on swap.** The layout above matches the existing hosts, where swap is a
> plain partition _outside_ LUKS. That leaks whatever the kernel pages out, and
> rules out hibernation onto an encrypted disk. If you would rather not: skip
> partition 2 entirely and add `swapDevices = [ { device = "/swapfile"; size =
8192; } ];` to the host's `configuration.nix` -- NixOS creates the file on
> first boot, inside the encrypted root.

### Recipe B -- no encryption

```sh
DISK=/dev/nvme0n1
sgdisk --zap-all "$DISK"
sgdisk -n1:0:+1G -t1:ef00 -c1:ESP  "$DISK"
sgdisk -n2:0:0   -t2:8300 -c2:root "$DISK"
partprobe "$DISK"
P="${DISK}p"

mkfs.ext4 -L nixos "${P}2"
mkfs.fat -F32 -n BOOT "${P}1"

mount "${P}2" /mnt
mkdir -p /mnt/boot
mount -o umask=0077 "${P}1" /mnt/boot
```

Before moving on, check that `/mnt` and `/mnt/boot` are both mounted --
`install-host` refuses to run otherwise:

```sh
findmnt /mnt /mnt/boot
```

## 3. Run the installer

```sh
install-host <host-name>
```

**The first run scaffolds and stops.** It copies the baked-in config to
`/root/nix`, points the `secrets` input at the local encrypted copy, and creates
`/root/nix/nixos/hosts/<host-name>/` from the template. Open
`configuration.nix` there and pick your modules -- keep `core`, or you get no
user to log in as.

**The second run installs.** It:

1. writes `_generated/hardware-configuration.nix` from what you mounted
   (`nixos-generate-config --root /mnt`), so filesystems and LUKS devices are
   detected rather than copied by hand;
2. prompts for your **age private key** (hidden input) and writes it to
   `/mnt/home/<user>/.config/sops/age/keys.txt`;
3. runs `nixos-install --flake .#<host-name>`.

Step 2 is what makes secrets work on the _first_ boot. `sops` decrypts your user
password during activation, before any home directory exists, so the key has to
be on disk before the system ever starts.

### Reinstalling a host that already exists in the repo

There is no scaffolding pause -- it installs straight away and **regenerates the
hardware config from whatever you mounted**, which is what you want when the
disk has been repartitioned. The previous file is kept as
`_generated/hardware-configuration.nix.bak`.

To reinstall without touching the hardware config:

```sh
install-host --keep-hardware <host-name>
```

> **Older hosts get converted.** `alae` and `legion` predate this layout: they
> declare their hardware config _inline_ in `hardware.nix` rather than importing
> `_generated/`. A regenerated file would be silently ignored there, and the
> install would use the old disk UUIDs. `install-host` detects this, rewrites
> `hardware.nix` into the one-line import form, and keeps the original as
> `hardware.nix.bak`. The module name is read out of `configuration.nix`, so
> irregular ones like `hostWSL` survive.

## 4. First boot

Just `reboot`. The repos clone themselves.

On first boot the `clone-repos` service runs, and by then `sops` has already
installed your SSH key at `~/.ssh/id_ed25519` (a symlink into `/run/secrets`),
so it can reach GitHub:

```
~/nix           <- git@github.com:Harro3/nix.git
~/nix-secrets   <- git@github.com:Harro3/nix-secrets.git
```

Existing directories are never touched, so this is safe to leave enabled
forever -- it only does anything on a machine that has neither.

That clone is a *clean* checkout, which will not contain the host you just
built. `install-host` left it in `~/.host-config` for exactly this reason:

```sh
cp -r ~/.host-config ~/nix/nixos/hosts/<host-name>
cd ~/nix && git add nixos/hosts/<host-name> && git commit -m "add <host-name>"
```

Push when you are happy with it. The clone has the real `git+ssh` secrets
input, so there is no leftover `path:` override to undo.

### Turning it off

It is on by default via the template's `clone-repos` import. To disable, or to
clone something else:

```nix
preferences.repos.enable = false;

# or
preferences.repos.clones = {
  nix = "git@github.com:Harro3/nix.git";
  notes = "git@github.com:Harro3/notes.git";
};
```

## What is actually on the ISO

Worth being precise, since the stick leaves your desk:

| Baked in           | Contents                                                                                      |
| ------------------ | --------------------------------------------------------------------------------------------- |
| `/etc/nix-config`  | this flake's source -- the public config repo                                                 |
| `/etc/nix-secrets` | `secrets.yaml` (every value `ENC[AES256_GCM,...]`) and `.sops.yaml` (your age **public** key) |

Your age **private** key is never on the ISO. It is pasted in at install time
and written straight to the target disk. The encrypted `secrets.yaml` is the
same file that already sits world-readable in `/nix/store` on every host running
this config, so the ISO exposes nothing new.

## Where the generated hardware config lives

`nixos-generate-config` emits a plain NixOS module, but every `.nix` file in
this repo is imported as a _flake-parts_ module. The generated file therefore
goes in `nixos/hosts/<host>/_generated/`, which `importTree` skips (underscore
prefix), and `hardware.nix` pulls it in:

```nix
{
  flake.nixosModules.hostMyhost = import ./_generated/hardware-configuration.nix;
}
```

## Fallback: the old manual route

Still valid if you have no ISO handy -- install stock NixOS, then:

```sh
nix-shell -p git vim
sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos
sudo nix-channel --update nixos
```

Add to `/etc/nixos/configuration.nix`, then `sudo nixos-rebuild switch`:

```nix
services.openssh.enable = true;
nix.settings.experimental-features = [ "nix-command" "flakes" ];
```

Generate a temporary SSH key, add it to GitHub, clone `nix` and `nix-secrets`,
put your age key in `~/.config/sops/age/keys.txt`, create
`nixos/hosts/<host>/` by copying an existing one, drop
`/etc/nixos/hardware-configuration.nix` into `_generated/`, then:

```sh
sudo nixos-rebuild boot --flake .#<host-name>
```

Reboot, remove the temporary key from GitHub, and `nh clean all`.
