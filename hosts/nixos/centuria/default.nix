{ pkgs, vars, inputs, ...}:
{
  imports = [
    inputs.nixos-wsl.nixosModules.default
    ../../common
  ];

  wsl.enable = true;
  wsl.defaultUser = "harro";

  networking.hostName = vars.hostname;
  networking.networkmanager.enable = true;
  nixpkgs.config.allowUnfree = true;

  # Modules
  hostmodules.pipewire.enable = false;
  hostmodules.bluetooth.enable = false;
  hostmodules.caps2esc.enable = false;
  hostmodules.catppuccin.enable = true;
  hostmodules.greetd.enable = false;
  hostmodules.grub.enable = false;
  hostmodules.hyprland.enable = false;
  hostmodules.hyprlock.enable = false;
  hostmodules.hyprshot.enable = false;
  hostmodules.kitty.enable = true;
  hostmodules.zsh.enable = true;
  hostmodules.wayland.enable = false;
  hostmodules.virtualisation.enable = false;
  hostmodules.appimage.enable = false;
  hostmodules.yubikey.enable = false;

  hostmodules.nvidia.enable = false;
  hostmodules.gaming.enable = false;

  # Services
  services.openssh.enable = true;

  # Additionnal packages
  environment.systemPackages = with pkgs; [
    wget
    git
    firefox
    vim
  ];

  system.stateVersion = "25.05";
}
