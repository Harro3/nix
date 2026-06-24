{ self, ... }: {
  flake.nixosModules.limine =
    {
      pkgs,
      lib,
      ...
    }:
    {
      boot.loader = {
        limine = {
          enable = true;
          efiSupport = true;
          biosSupport = false;
          maxGenerations = 16;
          validateChecksums = true;
          style = {
            wallpapers = [ self.wallpaper ];
            wallpaperStyle = "stretched";
            interface = {
              branding = "Inspiring quote here";
            };
          };
        };
        efi.canTouchEfiVariables = true;
      };
    };
}
