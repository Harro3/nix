{ self, ... }: {
  flake.nixosModules.desktop =
    {
      pkgs,
      config,
      ...
    }:
    {
      imports = [
        self.nixosModules.niri
      ];
    };
}