{inputs, self, ...}: {
  flake.nixosModules.pipewire = {pkgs, ...}: {
      environment.systemPackages = with pkgs; [
      playerctl
      pavucontrol
      pulseaudio
      pipewire
      wireplumber

      xdg-desktop-portal
      xdg-desktop-portal-wlr
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
    };
  };
}
