{
  lib,
  pkgs,
  config,
  ...
}: {
  options.darkTheme = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = ''
      Configures system theme to be dark
    '';
  };

  config = lib.mkIf config.darkTheme {
    gtk = {
      enable = true;
      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome-themes-extra;
      };
      iconTheme = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
      };
      gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
      gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
    };

    qt = {
      enable = true;
      style = {
        name = "adwaita-dark";
      };
    };

    home.sessionVariables = {
      GTK_THEME = "Adwaita-dark";
      QT_QPA_PLATFORMTHEME = "qt5ct";
    };
  };
}
