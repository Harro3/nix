{
  self,
  inputs,
  lib,
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

      self.nixosModules.user
      self.nixosModules.limine

      self.nixosModules.niri
    ];

    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    system.stateVersion = "26.05";
  };
}
