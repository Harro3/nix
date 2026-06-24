{self, inputs, ...}: {
  perSystem = {pkgs, lib, system, ...}: {
    packages.niri = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs;

      settings = {
        input = {
          keyboard = {
            xkb = {
              layout = "us";
              variant = "altgr-intl";
            };
            numlock = _: {};
          };

          touchpad = {
            tap = _: {};
            natural-scroll = _: {};
          };

          mouse = {};

          trackpoint = {};

        };

        cursor = {
          xcursor-theme = "Nordic-cursors";
          xcursor-size = 42;
          hide-after-inactive-ms = 5000;
          hide-when-typing = _: {};
        };

        environment = {
          XDG_CURRENT_DESKTOP = "niri";
          XDG_MENU_PREFIX = "plasma-";
          QT_QPA_PLATFORM = "wayland";
          GTK_THEME = "Adwaita:dark";
          QT_QPA_PLATFORMTHEME = "kde";
          QT_STYLE_OVERRIDE = "Darkly";
        };

        layout = {
          gaps = 16;
          background-color = "transparent";
          always-center-single-column = _: {};
          center-focused-column = "never";

          preset-column-widths = [
            { proportion = 0.33333; }
            { proportion = 0.5; }
            { proportion = 0.66667; }
          ];

          default-column-width = {
            proportion = 0.5;
          };

          focus-ring = {
            width = 4;

            active-gradient = _: {
              props = {
                from = "orange";
                to = "green";
                angle = 45;
                "in" = "oklch longer hue";
              };
            };
            inactive-gradient = _: {
              props = {
                from = "orange";
                to = "cyan";
                angle = 45;
                "in" = "oklch longer hue";
              };
            };
          };

          border = {
            off = _: {};
            width = 16;
            urgent-color = "red";
          };

          shadow = {
            softness = 30;
            spread = 5;
            color = "#0007";
            offset = _: {
              props = {
                x = 0;
                y = 5;
              };
            };
          };

          struts = {

          };
        };

        hotkey-overlay = {
          skip-at-startup = _: {};
        };

        prefer-no-csd = _: {};

        screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";
      };
    };
  };
}