{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    homemodules.hyprpaper.enable = lib.mkEnableOption "hyprpaper";
    hyprpaperWallpaperPath = lib.mkOption {
      type = lib.types.path;
      description = ''
        Path to wallpaper
      '';
    };
  };

  config = lib.mkIf config.homemodules.hyprpaper.enable {
    home.packages = with pkgs; [
      hyprpaper
    ];

    home.file.".config/hypr/hyprpaper.conf".text = ''
      wallpaper {
        monitor =
        path = ${config.hyprpaperWallpaperPath}
      }
    '';
  };
}
