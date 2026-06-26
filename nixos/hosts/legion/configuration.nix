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
      inputs.nixos-hardware.nixosModules.lenovo-legion-16arh7h-hybrid

      self.nixosModules.core

      self.nixosModules.boot
      self.nixosModules.desktop

      self.nixosModules.shell
      self.nixosModules.nix

      self.nixosModules.virtualization
      self.nixosModules.yubikey
    ];

    networking = {
      hostName = "legion";
      networkmanager.enable = true;
    };

    hardware.nvidia = {
      modesetting.enable = true;

      prime.offload = {
        enable = true;
        enableOffloadCmd = true;
      };
    };
    services.xserver.videoDrivers = [ "nvidia" ];

    environment.systemPackages = with pkgs; [
      firefox
    ];

    system.stateVersion = "26.05";
  };
}
