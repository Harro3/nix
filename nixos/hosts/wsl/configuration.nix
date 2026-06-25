{
  self,
  inputs,
  ...
}:
{
  flake.nixosConfigurations.wsl = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      self.nixosModules.hostWSL
    ];
  };

  flake.nixosModules.hostWSL = { pkgs, ... }: {
    imports = [
      self.nixosModules.core

      inputs.nixos-wsl.nixosModules.default

      self.nixosModules.shell
    ];

    networking.hostName = "wsl";
    wsl.wslConf.network.hostname = "wsl";

    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    wsl.enable = true;
    wsl.defaultUser = "harro";

    system.stateVersion = "26.05";
  };
}
