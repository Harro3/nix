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

      self.nixosModules.user

      self.nixosModules.grub
      self.nixosModules.greetd

      self.nixosModules.niri
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
