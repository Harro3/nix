{
  self,
  inputs,
  ...
}:
{
  flake.nixosConfigurations.legion = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.hostLegion
    ];
  };

  flake.nixosModules.hostLegion = { pkgs, ... }: {
    imports = [
      self.nixosModules.core

      self.nixosModules.boot
      self.nixosModules.desktop

      self.nixosModules.shell
      self.nixosModules.nix
    ];


    networking = {
      hostName = "legion";
      networkmanager.enable = true;
    };

    system.stateVersion = "26.05";
  };
}
