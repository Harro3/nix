{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.legion = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.hostLegion
    ];
  };

  flake.nixosModules.hostLegion = {pkgs, ...}: {
    imports = [
      self.nixosModules.core

      self.nixosModules.boot
      self.nixosModules.desktop
    ];

    environment.systemPackages = with pkgs; [
      git
    ];

    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    system.stateVersion = "26.05";
  };
}