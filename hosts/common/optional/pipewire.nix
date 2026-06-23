{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    hostmodules.pipewire.enable = lib.mkEnableOption "Pipewire config";
  };

  config = lib.mkIf config.hostmodules.pipewire.enable {
    environment.systemPackages = with pkgs; [
      playerctl
      pavucontrol
      pulseaudio
      pipewire
      wireplumber

      xdg-desktop-portal
      xdg-desktop-portal-wlr
      xdg-desktop-portal-hyprland
    ];

    services.pulseaudio.enable = false;
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      wireplumber.enable = true;
      audio.enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
    xdg.portal = {
      enable = true;
      extraPortals = lib.mkIf config.hostmodules.hyprland.enable [pkgs.xdg-desktop-portal-hyprland];
    };
  };
}
