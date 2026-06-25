{...}: {
flake.nixosModules.gtk = {
  pkgs,
  lib,
  ...
}: let
  theme-name = "Catppuccin-Mocha-Standard-Green-Dark";

  theme-package = pkgs.catppuccin-gtk.override {
    accents = [ "lavender" ];
    size = "standard";
    tweaks = [ ];
    variant = "mocha";
  };

  icon-theme-package = pkgs.catppuccin-papirus-folders.override {
    flavor = "mocha";
    accent = "lavender";
  };

  icon-theme-name = "Papirus-Dark";
  # Depending on package version, this may instead be
  # "Papirus-Dark" or a Catppuccin-specific variant.

  gtksettings = ''
    [Settings]
    gtk-icon-theme-name = ${icon-theme-name}
    gtk-theme-name = ${theme-name}
  '';
in {
  environment = {
    etc = {
      "xdg/gtk-3.0/settings.ini".text = gtksettings;
      "xdg/gtk-4.0/settings.ini".text = gtksettings;
    };
  };

  environment.variables = {
    GTK_THEME = theme-name;
  };

  programs.dconf = {
    enable = lib.mkDefault true;

    profiles.user.databases = [
      {
        lockAll = false;
        settings = {
          "org/gnome/desktop/interface" = {
            gtk-theme = theme-name;
            icon-theme = icon-theme-name;
            color-scheme = "prefer-dark";
          };
        };
      }
    ];
  };

  environment.systemPackages = [
    theme-package
    icon-theme-package

    pkgs.gtk3
    pkgs.gtk4
  ];
};
}
