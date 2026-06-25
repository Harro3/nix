{self, ...}: {
  flake.nixosModules.grub =
    {
      pkgs,
      lib,
      ...
    }: {
      boot.loader = {
        efi.canTouchEfiVariables = true;

        grub = {
          enable = true;
          efiSupport = true;
          device = "nodev";
          useOSProber = true;
          theme = ./theme;
        };
      };
    };
}