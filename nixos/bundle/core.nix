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
        self.nixosModules.caps-remap
        self.nixosModules.nix
        self.nixosModules.gtk
        self.nixosModules.documentation
        self.nixosModules.locales
        self.nixosModules.fonts
      ];
    };
}
