{ inputs, ... }: {
  perSystem =
    {
      pkgs,
      lib,
      system,
      self',
      ...
    }:
    {
      packages.niri = inputs.wrapper-modules.wrappers.niri.wrap {
        inherit pkgs;

        settings =
          let
            noctaliaExe = lib.getExe self'.packages.noctalia-shell;
          in
          {
            input = {
              focus-follows-mouse = _: { };
              mod-key = "Alt";
              mod-key-nested = "Super";
              keyboard = {
                xkb = {
                  layout = "us";
                  variant = "altgr-intl";
                };
                numlock = _: { };
              };

              touchpad = {
                tap = _: { };
                natural-scroll = _: { };
              };

              mouse = {
                accel-profile = "flat";
              };

              trackpoint = { };
            };

            cursor = {
              xcursor-theme = "Nordic-cursors";
              xcursor-size = 24;
              hide-after-inactive-ms = 5000;
              hide-when-typing = _: { };
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
              gaps = 12;
              background-color = "transparent";
              always-center-single-column = _: { };
              center-focused-column = "never";

              preset-column-widths = [
                { proportion = 0.5; }
                { proportion = 0.75; }
                { proportion = 1.0; }
              ];

              default-column-width = {
                proportion = 0.5;
              };

              focus-ring = {
                active-color = "#7287fd";
                width = 4;
              };

              border = {
                off = _: { };
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

            spawn-at-startup = [
              noctaliaExe
            ];

            hotkey-overlay = {
              skip-at-startup = _: { };
            };

            prefer-no-csd = _: { };

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

            workspaces = {
              w1 = { };
              w2 = { };
              w3 = { };
              w4 = { };
            };

            overview = {
              zoom = 0.5;
              workspace-shadow = {
                off = _: { };
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
              "Mod+Return".spawn-sh = lib.getExe self'.packages.kitty;

              "Mod+Q".close-window = _: { };
              "Mod+F".maximize-column = _: { };
              "Mod+G".fullscreen-window = _: { };
              "Mod+Shift+F".toggle-window-floating = _: { };
              "Mod+C".center-column = _: { };

              "Mod+Shift+R".switch-preset-window-height = _: { };

              "Mod+H".focus-column-left = _: { };
              "Mod+L".focus-column-right = _: { };
              "Mod+K".focus-window-up = _: { };
              "Mod+J".focus-window-down = _: { };

              "Mod+Shift+C".center-visible-columns = _: { };

              "Mod+Left".focus-column-left = _: { };
              "Mod+Right".focus-column-right = _: { };
              "Mod+Up".focus-window-up = _: { };
              "Mod+Down".focus-window-down = _: { };

              "Mod+Shift+H".move-column-left = _: { };
              "Mod+Shift+L".move-column-right = _: { };
              "Mod+Shift+K".move-window-up = _: { };
              "Mod+Shift+J".move-window-down = _: { };

              "Mod+U".focus-workspace-down = _: { };
              "Mod+I".focus-workspace-up = _: { };

              "Mod+Shift+U".move-column-to-workspace-down = _: { };
              "Mod+Shift+I".move-column-to-workspace-up = _: { };

              "Mod+1".focus-workspace = 1;
              "Mod+2".focus-workspace = 2;
              "Mod+3".focus-workspace = 3;
              "Mod+4".focus-workspace = 4;
              "Mod+5".focus-workspace = 5;
              "Mod+6".focus-workspace = 6;
              "Mod+7".focus-workspace = 7;
              "Mod+8".focus-workspace = 8;
              "Mod+9".focus-workspace = 9;

              "Mod+Shift+1".move-column-to-workspace = 1;
              "Mod+Shift+2".move-column-to-workspace = 2;
              "Mod+Shift+3".move-column-to-workspace = 3;
              "Mod+Shift+4".move-column-to-workspace = 4;
              "Mod+Shift+5".move-column-to-workspace = 5;
              "Mod+Shift+6".move-column-to-workspace = 6;
              "Mod+Shift+7".move-column-to-workspace = 7;
              "Mod+Shift+8".move-column-to-workspace = 8;
              "Mod+Shift+9".move-column-to-workspace = 9;

              "Mod+Shift+BracketLeft".consume-or-expel-window-left = _: { };
              "Mod+Shift+BracketRight".consume-or-expel-window-right = _: { };

              "Mod+D".spawn-sh = "${noctaliaExe} ipc call launcher toggle";
              "Mod+X".spawn-sh = "${noctaliaExe} ipc call lockScreen lock";
              "Mod+B".spawn-sh = lib.getExe pkgs.firefox;

              "XF86AudioRaiseVolume".spawn-sh = "wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+";
              "XF86AudioLowerVolume".spawn-sh = "wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-";
              "XF86AudioMute".spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
              "XF86AudioMicMute".spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";

              "XF86AudioPlay".spawn-sh = "${lib.getExe pkgs.playerctl} play";
              "XF86AudioPause".spawn-sh = "${lib.getExe pkgs.playerctl} pause";
              "XF86AudioStop".spawn-sh = "${lib.getExe pkgs.playerctl} stop";
              "XF86AudioNext".spawn-sh = "${lib.getExe pkgs.playerctl} next";
              "XF86AudioPrev".spawn-sh = "${lib.getExe pkgs.playerctl} previous";

              "XF86MonBrightnessUp".spawn-sh = "${lib.getExe pkgs.brightnessctl} --class=backlight set +10%";
              "XF86MonBrightnessDown".spawn-sh = "${lib.getExe pkgs.brightnessctl} --class=backlight set 10%-";

              "Mod+O".toggle-overview = _: { };

              "Mod+Ctrl+Shift+H".set-column-width = "-5%";
              "Mod+Ctrl+Shift+L".set-column-width = "+5%";
              "Mod+Ctrl+Shift+J".set-window-height = "-5%";
              "Mod+Ctrl+Shift+K".set-window-height = "+5%";

              "Mod+comma".focus-monitor-left = _: { };
              "Mod+period".focus-monitor-right = _: { };
              "Mod+Shift+comma".move-workspace-to-monitor-left = _: { };
              "Mod+Shift+period".move-workspace-to-monitor-right = _: { };

              "Mod+WheelScrollDown".focus-column-left = _: { };
              "Mod+WheelScrollUp".focus-column-right = _: { };
              "Mod+Ctrl+WheelScrollDown".focus-workspace-down = _: { };
              "Mod+Ctrl+WheelScrollUp".focus-workspace-up = _: { };

              "Mod+Shift+S".spawn-sh = "${lib.getExe pkgs.hyprshot} -m region -o ~/Pictures/Screenshots/";
            };

            window-rules = [
              {
                matches = [
                  {
                    app-id = "firefox";
                  }
                ];
                open-on-workspace = "w2";
                open-maximized = true;
              }
              {
                matches = [
                  {
                    app-id = "discord";
                  }
                ];
                open-on-workspace = "w3";
                open-maximized = true;
              }
              {
                matches = [
                  {
                    title = "Spotify Premium";
                  }
                ];
                open-on-workspace = "w4";
                open-maximized = true;
              }

              {
                geometry-corner-radius = 12;
                clip-to-geometry = true;
              }
              {
                matches = [
                  {
                    app-id = "kitty$";
                    is-active = false;
                  }
                ];
                opacity = 0.85;
              }
              {
                matches = [
                  {
                    app-id = "kitty$";
                    is-active = true;
                  }
                ];
                opacity = 0.9;
              }
            ];
          };
      };
    };
}
