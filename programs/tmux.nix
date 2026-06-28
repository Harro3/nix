{ inputs, ... }: {
  perSystem =
    {
      pkgs,
      lib,
      self',
      ...
    }:
    {
      packages.tmux = inputs.wrapper-modules.wrappers.tmux.wrap {
        inherit pkgs;

        plugins = with pkgs.tmuxPlugins; [
          vim-tmux-navigator
          yank
          catppuccin

          battery
          cpu
        ];

        configBefore = ''
          unbind r
          set-option -sa terminal-overrides ",xterm*:Tc"

          set -g default-terminal "tmux-256color"

          set -g prefix C-a
          set -g mouse on
          bind-key h select-pane -L
          bind-key j select-pane -D
          bind-key k select-pane -U
          bind-key l select-pane -R

          bind C-l send-keys 'C-l'

          set -g base-index 1
          set -g pane-base-index 1
          set-window-option -g pane-base-index 1
          set-option -g renumber-windows on

          set-option -g status-position top

          setw -g mode-keys vi
          bind-key -T copy-mode-vi v send-keys -X begin-selection
          bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
          bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
          set -g set-clipboard on

          bind '"' split-window -v -c "#{pane_current-path}"
          bind % split-window -h -c "#{pane_current_path}"


          set -gq allow-passthrough on

          set -g automatic-rename-format '#{b:pane_current_path}'

          # Configure the catppuccin plugin
          set -g @catppuccin_flavor "mocha"
          set -g @catppuccin_window_status_style "rounded"
          set -g @catppuccin_directory_text "#{pane_current_path}"


          set -g @catppuccin_window_number_position "right"
          set -g @catppuccin_window_default_fill "number"
          set -g @catppuccin_window_default_text "#W"

          set -g @catppuccin_window_current_fill "number"
          set -g @catppuccin_window_current_text "#W"


        '';

        configAfter = ''
          # Make the status line pretty and add some modules
          set -g status-right-length 100
          set -g status-left-length 100

          set -g status-left ""
          set -g status-right "#{E:@catppuccin_status_application}"
          # set -agF status-right "#{E:@catppuccin_status_cpu}"
          set -agF status-right "#{E:@catppuccin_status_ram}"
          set -ag status-right "#{E:@catppuccin_status_session}"
          set -ag status-right "#{E:@catppuccin_status_uptime}"
          # set -agF status-right "#{E:@catppuccin_status_battery}"
        '';
      };
    };
}
