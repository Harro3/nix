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
      ];
      config = {
        environment.sessionVariables.NIXOS_OZONE_WL = "1";
        environment.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";
        environment.sessionVariables.MOZ_ENABLE_WAYLAND = "1";
        environment.sessionVariables.XDG_SESSION_TYPE = "wayland";

        services.upower.enable = true;

        programs.niri.enable = true;
        programs.niri.package = selfpkgs.niri;

        environment.systemPackages = [
          selfpkgs.kitty

          pkgs.xwayland-satellite
          pkgs.spotify
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
