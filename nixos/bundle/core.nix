{ self, ... }: {
  flake.nixosModules.core =
    {
      pkgs,
      config,
      ...
    }:
    {
      imports = [
	self.nixosModules.user
	self.nixosModules.nix
	self.nixosModules.gtk
	self.nixosModules.secrets
      ];
    };
}
