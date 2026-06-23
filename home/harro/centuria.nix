{pkgs, ...}: {
  imports = [
    ./common
  ];

  # General config
  home.username = "harro";
  home.homeDirectory = "/home/harro";
  hyprpaperWallpaperPath = ./wallpapers/mountains.jpg;

  nixpkgs.config.allowUnfree = true;

  # Modules
  homemodules.waybar.enable = false;
  homemodules.wofi.enable = false;
  homemodules.firefox.enable = true;
  homemodules.hypridle.enable = false;
  homemodules.hyprland.enable = false;
  homemodules.hyprlock.enable = false;
  homemodules.hyprpaper.enable = false;
  homemodules.mako.enable = false;
  homemodules.tmux.enable = true;
  homemodules.gemini.enable = true;
  homemodules.sesh.enable = true;
  homemodules.kicad.enable = false;

  # Nixvim langs
  nvim.lang = {
    bash.enable = true;
    c.enable = false;
    docker.enable = true;
    json.enable = true;
    markdown.enable = true;
    nix.enable = true;
    obsidian.enable = false;
    python.enable = true;
    yaml.enable = true;
    rust.enable = true;
    arduino.enable = false;

    tex.enable = false;
  };

  # Packages
  home.packages = with pkgs; [
    # Desktop
    vlc
    ffmpeg

    # Utils
    zip
    unzip
    zathura
    wl-clipboard
    jq
    appimage-run

    # Workflow
    lazygit
    nh

    python312
    docker-compose

    bottles
    savvycan

    restream
  ];

  home.stateVersion = "24.05";
  programs.home-manager.enable = true;
}
