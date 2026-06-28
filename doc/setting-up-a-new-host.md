# Settings up a new host

This document goes through the steps to take in order to add a new host to be managed by the config.
The process described is still manual, but I plan on maybe making an automatic version of it.

## Install basic NixOS

- Boot on the **NixOS** live ISO installer
- Start the installer
- Install nixos (with or without DE)
- Reboot on fresh install
- Enter a dev shell with needed tools

```bash
nix-shell -p git vim
```

- Add a root channel

```bash
sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos
sudo nix-channel --update nixos
```

- Add those lines to `/etc/nixos/configuration.nix`

```bash
services.openssh.enable = true;
nix.settings.experimental-features = ["nix-command" "flakes"];
```

- Rebuild the system

```bash
sudo nixos-rebuild switch
```

## Gain access to config repos

- Generate a temporary ssh key for your user (we will delete it soon)
- Add the ssh key to your github / gitlab account (with the config and secrets repos)
- Clone both repos, in my case:

```sh
git clone git@github.com:Harro3/nix.git
git clone git@github.com:Harro3/nix-secrets.git
```

## Setup host config

- Get your private age key and store it in `~/.config/sops/age/keys.txt`:

```sh
mkdir -p ~/.config/sops/age
echo '<my-age-key>' > ~/.config/sops/age/keys.txt
```

- Create the host's config file:

```sh
mkdir -p nixos/hosts/<host-name>
touch nixos/hosts/<host-name>/configuration.nix
```

- Edit the config as you like, taking inspiration on an existing one
- Is is **strongly** recommended to enable at least the **core** nixos module, as if not, you will not have a user to login with
- Copy the hardware config:

```sh
cp /etc/nixos/hardware-configuration.nix nixos/hosts/<host-name>
```

- Build the system

```sh
sudo nixos-rebuild boot --flake .#<host-name>
```

- Reboot

## Cleanup

- Remove the ssh key from github
- run a `nh clean all`
