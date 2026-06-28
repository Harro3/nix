{ self, ... }: {
  flake.nixosModules.desktop =
    {
      pkgs,
      config,
      ...
    }:
    let
      selfpkgs = self.packages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      imports = [
        self.nixosModules.bluetooth
        self.nixosModules.pipewire
        self.nixosModules.wayland
      ];
      config = {
        services.upower.enable = true;

        programs.niri.enable = true;
        programs.niri.package = selfpkgs.niri;

        environment.systemPackages = [
          selfpkgs.kitty

          pkgs.firefox
          pkgs.vlc
          pkgs.libreoffice
          pkgs.discord
          pkgs.wl-clipboard
          pkgs.appimage-run
          pkgs.protonmail-desktop
          pkgs.proton-vpn
          pkgs.proton-pass
        ];
      };
    };
}
