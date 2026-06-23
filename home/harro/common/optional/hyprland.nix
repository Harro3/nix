{
  pkgs,
  lib,
  config,
  ...
}: let
  volumeScript = pkgs.writeShellApplication {
    name = "volumeScript";
    runtimeInputs = [pkgs.libnotify];
    text = ''
      #!/bin/sh

            volume_step=1
            max_volume=100

            get_volume() {
            	pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '[0-9]{1,3}(?=%)' | head -1
            }

            get_mute() {
            	pactl get-sink-mute @DEFAULT_SINK@ | grep -Po '(?<=Mute: )(yes|no)'
            }

            display_volume() {
            	volume=$(get_volume)
            	mute=$(get_mute)

            	if [ "$volume" -eq 0 ] || [ "$mute" = "yes" ] ; then
            		volume_icon=""
            	elif [ "$volume" -lt 50 ]; then
            		volume_icon=""
            	else
            		volume_icon=""
            	fi

            	notify-send -h string:x-canonical-private-synchronous:sys-notify -t 1000 -u normal "$volume_icon $volume%" -h "int:value:$volume"
            }

            case $1 in
                up)
                pactl set-sink-mute @DEFAULT_SINK@ 0
                volume=$(get_volume)
                if [ $(( "$volume" + "$volume_step" )) -gt $max_volume ]; then
                    pactl set-sink-volume @DEFAULT_SINK@ $max_volume%
                else
                    pactl set-sink-volume @DEFAULT_SINK@ +$volume_step%
                fi
                display_volume
                ;;

                 down)
                # Raises volume and displays the notification
                pactl set-sink-volume @DEFAULT_SINK@ -$volume_step%
                display_volume
                ;;

                mute)
                # Toggles mute and displays the notification
                pactl set-sink-mute @DEFAULT_SINK@ toggle
                display_volume
                ;;
            esac
    '';
  };
  brightnessScript = pkgs.writeShellApplication {
    name = "brightnessScript";
    runtimeInputs = [pkgs.brightnessctl pkgs.libnotify];
    text = ''
      #!/bin/sh
      get_brightness() {
      	brightnessctl i | grep -o '[0-9]*%' | sed 's/.$//'
      }


      show_brightness() {
      	brightness=$(get_brightness)
      	notify-send -h string:x-canonical-private-synchronous:sys-notify -t 1000 -u normal " $brightness%" -h "int:value:$brightness"
      }

      brightness_down() {
      	brightnessctl s 5%-
      	show_brightness
      }

      brightness_up() {
      	brightnessctl s 5%+
      	show_brightness
      }

      case "$1" in
      	up)
      		brightness_up
      		;;
      	down)
      		brightness_down
      		;;
      esac
    '';
  };
  wofiEmojiScript = pkgs.writeShellApplication {
    name = "wofiEmojiScript";
    runtimeInputs = [];
    text = ''
      #!/bin/sh

      VER='15.1'
      URL="https://www.unicode.org/Public/emoji/$VER/emoji-test.txt"
      DIR="$HOME/.cache"
      FILE="$DIR/emojis.txt"

      if [ ! -r "$FILE" ]
      then
        if [ ! -d "$DIR" ]; then mkdir "$DIR"; fi
        curl --compressed "$URL" | sed -nE 's/^.+fully-qualified\s+#\s(\S+) E[0-9.]+ / \1 /p' > "$FILE"
      fi

      if [ "$@" ]
      then
        smiley=$(echo "$@" | cut -d' ' -f1)
        printf '%s' "$smiley" | wl-copy
        exit 0
      fi

      cat "$FILE"
    '';
  };

  darkThemeConfig =
    if !config.darkTheme
    then ""
    else ''
      ##################
      ### DARK THEME ###
      ##################

      exec-once = systemctl --user import-environment GTK_THEME QT_QPA_PLATFORMTHEME
    '';
in {
  options = {
    homemodules.hyprland.enable = lib.mkEnableOption "hyprland";
  };

  config = lib.mkIf config.homemodules.hyprland.enable {
    home.packages = with pkgs; [
      hyprshot
    ];

    wayland.windowManager.hyprland.xwayland.enable = true;

    catppuccin.hyprland.enable = true;

    home.file.".config/hypr/hyprland.conf".text = ''
      ${darkThemeConfig}

      ################
      ### MONITORS ###
      ################

      # See https://wiki.hyprland.org/Configuring/Monitors/
      monitor=,preferred,auto,auto


      ###################
      ### MY PROGRAMS ###
      ###################

      # See https://wiki.hyprland.org/Configuring/Keywords/

      # Set programs that you use
      $terminal = kitty
      $fileManager = yazi


      #################
      ### AUTOSTART ###
      #################

      # Autostart necessary processes (like notifications daemons, status bars, etc.)
      # Or execute your favorite apps at launch like this:




      exec-once = waybar
      exec-once = hyprpaper
      exec-once = hypridle
      # exec-once = $terminal
      # exec-once = nm-applet &
      # exec-once = waybar & hyprpaper & firefox


      #############################
      ### ENVIRONMENT VARIABLES ###
      #############################

      # See https://wiki.hyprland.org/Configuring/Environment-variables/

      env = XCURSOR_SIZE,24
      env = HYPRCURSOR_SIZE,24


      #####################
      ### LOOK AND FEEL ###
      #####################

      # Refer to https://wiki.hyprland.org/Configuring/Variables/

      # https://wiki.hyprland.org/Configuring/Variables/#general
      $lavender = rgb(b4befe)
      $overlay0 = rgb(6c7086)
      general {
          gaps_in = 6
          gaps_out = 3

          border_size = 2

          # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
          col.active_border = $lavender $lavender
          col.inactive_border = $overlay0 $overlay0

          # Set to true enable resizing windows by clicking and dragging on borders and gaps
          resize_on_border = false

          # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
          allow_tearing = false

          layout = dwindle
      }

      # https://wiki.hyprland.org/Configuring/Variables/#decoration
      decoration {
          rounding = 10

          # Change transparency of focused and unfocused windows
          active_opacity = 1.0
          inactive_opacity = 1.0

          # drop_shadow = true
          # shadow_range = 4
          # shadow_render_power = 3
          # col.shadow = rgba(1a1a1aee)

          # https://wiki.hyprland.org/Configuring/Variables/#blur
          blur {
              enabled = true
              size = 3
              passes = 1

              vibrancy = 0.1696
          }
      }


      # https://wiki.hyprland.org/Configuring/Variables/#animations
      animations {
          enabled = true

          # Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

          bezier = myBezier, 0.05, 0.9, 0.1, 1.05

          animation = windows, 1, 7, myBezier
          animation = windowsOut, 1, 7, default, popin 80%
          animation = border, 1, 10, default
          animation = borderangle, 1, 8, default
          animation = fade, 1, 7, default
          animation = workspaces, 1, 6, default
      }

      # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
      dwindle {
          preserve_split = true # You probably want this
      }

      # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
      master {
          new_status = master
      }

      # https://wiki.hyprland.org/Configuring/Variables/#misc
      misc {
          force_default_wallpaper = -1 # Set to 0 or 1 to disable the anime mascot wallpapers
          disable_hyprland_logo = true # If true disables the random hyprland logo / anime girl background. :(
          disable_splash_rendering = true
      }


      #############
      ### INPUT ###
      #############

      # https://wiki.hyprland.org/Configuring/Variables/#input
      input {
          kb_layout = us
          kb_variant = altgr-intl
          kb_model =
          kb_options =
          kb_rules =

          follow_mouse = 1

          sensitivity = 0 # -1.0 - 1.0, 0 means no modification.

          touchpad {
              natural_scroll = false
          }
      }

      # Example per-device config
      # See https://wiki.hyprland.org/Configuring/Keywords/#per-device-input-configs for more
      device {
          name = epic-mouse-v1
          sensitivity = -0.5
      }

      cursor {
        no_hardware_cursors = true
      }

      ###################
      ### KEYBINDINGS ###
      ###################

      # See https://wiki.hyprland.org/Configuring/Keywords/
      $mainMod = ALT

      # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
      bind = $mainMod, Return, exec, $terminal
      bind = $mainMod, Q, killactive,
      bind = $mainMod, Space, togglefloating,

      # wofi
      bind = $mainMod, D, exec, wofi --show drun
      bind = $mainMod, R, exec, wofi --show run
      bind = $mainMod, M, exec, echo -n $(${lib.getExe wofiEmojiScript} | wofi --dmenu 2> /dev/null | cut -d' ' -f2) | wl-copy

      # The sims
      bind = $mainMod, Z, exec, /bin/sh -c 'WINEPREFIX="$HOME/Games/ea-app" wine "$HOME/Games/ea-app/drive_c/Program Files/EA Games/The Sims 4/Game-cracked/Bin/TS4_x64.exe"'


      # bind = $mainMod, P, pseudo, # dwindle

      # Move focus with mainMod + arrow keys
      bind = $mainMod, H, movefocus, l
      bind = $mainMod, L, movefocus, r
      bind = $mainMod, K, movefocus, u
      bind = $mainMod, J, movefocus, d

      # Lock
      bind = $mainMod, X, exec, hyprlock

      # Switch workspaces with mainMod + [0-9]
      bind = $mainMod, 1, workspace, 1
      bind = $mainMod, 2, workspace, 2
      bind = $mainMod, 3, workspace, 3
      bind = $mainMod, 4, workspace, 4
      bind = $mainMod, 5, workspace, 5
      bind = $mainMod, 6, workspace, 6
      bind = $mainMod, 7, workspace, 7
      bind = $mainMod, 8, workspace, 8
      bind = $mainMod, 9, workspace, 9
      bind = $mainMod, 0, workspace, 10

      # Move window to direction
      bind =  $mainMod SHIFT, h, movewindow, l
      bind =  $mainMod SHIFT, j, movewindow, d
      bind =  $mainMod SHIFT, k, movewindow, u
      bind =  $mainMod SHIFT, l, movewindow, r

      # Move window

      bind = $mainMod, F, fullscreen

      # Move active window to a workspace with mainMod + SHIFT + [0-9]
      bind = $mainMod SHIFT, 1, movetoworkspace, 1
      bind = $mainMod SHIFT, 2, movetoworkspace, 2
      bind = $mainMod SHIFT, 3, movetoworkspace, 3
      bind = $mainMod SHIFT, 4, movetoworkspace, 4
      bind = $mainMod SHIFT, 5, movetoworkspace, 5
      bind = $mainMod SHIFT, 6, movetoworkspace, 6
      bind = $mainMod SHIFT, 7, movetoworkspace, 7
      bind = $mainMod SHIFT, 8, movetoworkspace, 8
      bind = $mainMod SHIFT, 9, movetoworkspace, 9
      bind = $mainMod SHIFT, 0, movetoworkspace, 10

      # Scroll through existing workspaces with mainMod + scroll
      bind = $mainMod, mouse_down, workspace, e+1
      bind = $mainMod, mouse_up, workspace, e-1

      # Move/resize windows with mainMod + LMB/RMB and dragging
      bindm = $mainMod, mouse:272, movewindow
      bindm = $mainMod, mouse:273, resizewindow

      # Laptop multimedia keys for volume and LCD brightness
      bindel = ,XF86AudioRaiseVolume, exec, sh "${lib.getExe volumeScript}" up
      bindel = ,XF86AudioLowerVolume, exec, sh "${lib.getExe volumeScript}" down
      bindel = ,XF86AudioMute, exec, sh "${lib.getExe volumeScript}" mute
      # bindel = ,XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
      bindel = ,XF86MonBrightnessUp, exec, sh "${lib.getExe brightnessScript}" up
      bindel = ,XF86MonBrightnessDown, exec, sh "${lib.getExe brightnessScript}" down

      # Requires playerctl
      bindl = , XF86AudioNext, exec, playerctl next
      bindl = , XF86AudioPause, exec, playerctl play-pause
      bindl = , XF86AudioPlay, exec, playerctl play-pause
      bindl = , XF86AudioPrev, exec, playerctl previous

      ##############################
      ### WINDOWS AND WORKSPACES ###
      ##############################

      # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
      # See https://wiki.hyprland.org/Configuring/Workspace-Rules/ for workspace rules

      bind = $mainMod SHIFT, code:59, movecurrentworkspacetomonitor, l
      bind = $mainMod SHIFT, code:60, movecurrentworkspacetomonitor, r

      windowrule = match:class ^(kitty)$, opacity 0.8 override 0.7 override

      windowrule = match:class ^(firefox)$, workspace 2
      windowrule = match:class ^(discord)$, workspace 3
      windowrule = match:title ^(Spotify Premium)$, workspace 4

      bind = $mainMod SHIFT, S, exec, hyprshot -m region
    '';
  };
}
