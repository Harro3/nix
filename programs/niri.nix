{self, inputs, ...}: {
  perSystem = {pkgs, lib, system, self', ...}: {
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

        animations = {
          slowdown = 2.0;
          window-open = {
            duration-ms = 200;
            curve = "linear";
            custom-shader = ''
        vec4 expanding_circle(vec3 coords_geo, vec3 size_geo) {
            vec3 coords_tex = niri_geo_to_tex * coords_geo;
            vec4 color = texture2D(niri_tex, coords_tex.st);
            vec2 coords = (coords_geo.xy - vec2(0.5, 0.5)) * size_geo.xy * 2.0;
            coords = coords / length(size_geo.xy);
            float p = niri_clamped_progress;
            if (p * p <= dot(coords, coords))
                color = vec4(0.0);

            return color;
        }

        vec4 open_color(vec3 coords_geo, vec3 size_geo) {
            return expanding_circle(coords_geo, size_geo);
        }
            '';
          };

          window-close = {
            duration-ms = 250;
            curve = "linear";
            custom-shader = ''
        vec4 fall_and_rotate(vec3 coords_geo, vec3 size_geo) {
            float progress = niri_clamped_progress * niri_clamped_progress;
            vec2 coords = (coords_geo.xy - vec2(0.5, 1.0)) * size_geo.xy;
            coords.y -= progress * 1440.0;
            float random = (niri_random_seed - 0.5) / 2.0;
            random = sign(random) - random;
            float max_angle = 0.5 * random;
            float angle = progress * max_angle;
            mat2 rotate = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
            coords = rotate * coords;
            coords_geo = vec3(coords / size_geo.xy + vec2(0.5, 1.0), 1.0);
            vec3 coords_tex = niri_geo_to_tex * coords_geo;
            vec4 color = texture2D(niri_tex, coords_tex.st);

            return color;
        }

        vec4 close_color(vec3 coords_geo, vec3 size_geo) {
            return fall_and_rotate(coords_geo, size_geo);
        }
            '';
          };
        };

        workspace = "main";

        overview = {
          zoom = 0.5;
          workspace-shadow = {
            off = _: {};
          };
        };

        layer-rule = {
          match = _: {
            props = {
              namespace = "^wallpaper$";
            };
          };
          place-within-backdrop = true;
        };

        binds = {
          "Mod+Return".spawn-sh = lib.getExe pkgs.kitty;
          "Mod+D".spawn = lib.getExe self'.packages.fuzzel;
          "Mod+Q".close-window = _: {};
        };
      };
    };
  };
}