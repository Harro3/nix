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
  homemodules.waybar.enable = true;
  homemodules.wofi.enable = true;
  homemodules.firefox.enable = true;
  homemodules.hypridle.enable = true;
  homemodules.hyprland.enable = true;
  homemodules.hyprlock.enable = true;
  homemodules.hyprpaper.enable = true;
  homemodules.mako.enable = true;
  homemodules.tmux.enable = true;
  homemodules.gemini.enable = true;
  homemodules.sesh.enable = true;

  homemodules.kicad.enable = true;

  # Nixvim langs
  nvim.lang = {
    bash.enable = true;
    c.enable = true;
    docker.enable = true;
    json.enable = true;
    markdown.enable = true;
    nix.enable = true;
    obsidian.enable = true;
    python.enable = true;
    yaml.enable = true;
    rust.enable = true;
    arduino.enable = true;

    tex.enable = true;
  };

  # Packages
  home.packages = with pkgs; [
    # Desktop
    libreoffice
    discord
    spotify
    wdisplays
    chromium
    vlc
    ffmpeg

    # Utils
    gcc
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

    protonmail-desktop
    # protonvpn-gui
    # proton-pass
  ];

  home.stateVersion = "24.05";
  programs.home-manager.enable = true;
}
