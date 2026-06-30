{
  self,
  inputs,
  ...
}:
{
  flake.nixosConfigurations.alae = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.hostAlae
    ];
  };

  flake.nixosModules.hostAlae = { pkgs, ... }: {
    imports = [
      self.nixosModules.core

      self.nixosModules.boot
      self.nixosModules.desktop
      self.nixosModules.secrets

      self.nixosModules.shell
      self.nixosModules.nix

      self.nixosModules.virtualization
    ];

    networking = {
      hostName = "alae";
      networkmanager.enable = true;
    };

    environment.systemPackages = with pkgs; [
      python313
      docker-compose
      mistral-vibe
      docker
    ];

    virtualisation.docker.enable = true;

    system.stateVersion = "26.05";
  };
}
