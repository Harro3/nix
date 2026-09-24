# Template for a new host. Copied and substituted by `install-host`.
# The _template directory is skipped by the flake's importTree, so it never
# has to evaluate as-is.
{
  self,
  inputs,
  ...
}:
{
  flake.nixosConfigurations.HOSTNAME = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.hostMODULE
    ];
  };

  flake.nixosModules.hostMODULE = { pkgs, ... }: {
    imports = [
      # core gives you a user to log in with -- do not drop it.
      self.nixosModules.core

      self.nixosModules.boot
      self.nixosModules.desktop
      self.nixosModules.secrets

      self.nixosModules.shell
      self.nixosModules.nix

      # Clones ~/nix and ~/nix-secrets on first boot, once sops has
      # installed the SSH key.
      self.nixosModules.clone-repos

      # Drop the ones you do not want:
      self.nixosModules.virtualization
      # self.nixosModules.yubikey
    ];

    networking = {
      hostName = "HOSTNAME";
      networkmanager.enable = true;
    };

    environment.systemPackages = with pkgs; [ ];

    system.stateVersion = "26.05";
  };
}
