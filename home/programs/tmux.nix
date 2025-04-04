{pkgs, ...}: let
  inherit (import ../../nixos/modules/variables.nix) shell currentTheme;
in {
  programs.tmux = {
    enable = true;
    clock24 = true;
    shell = "${pkgs.${shell}}/bin/${shell}";
    terminal = "tmux-256color";
    prefix = "C-a";
    mouse = true;
    baseIndex = 1;
    escapeTime = 0;
    historyLimit = 10000;
    extraConfig = ''
          set -sa terminal-overrides ",xterm*:Tc"
          set -g renumber-windows on

          # Reload with prefix-r
          bind r source-file ~/.config/tmux/tmux.conf \; display "Config reloaded."

          # Make new windows/splits keep CWD
          bind -n M-n new-window -c "#{pane_current_path}"
          bind -n M-SPACE split-window -c "#{pane_current_path}"
          bind -n M-v split-window -h -c "#{pane_current_path}"
          bind g display-popup -B -d "#{pane_current_path}" -xC -yC -w100% -h100% -E 'lazygit'

          bind -n M-q kill-pane

          bind -n M-SPACE choose-window "join-pane -v -s "%%""
          bind -n M-V choose-window "join-pane -h -s "%%""

          # pane vim-navigation
          bind -n M-h select-pane -L
          bind -n M-j select-pane -D
          bind -n M-k select-pane -U
          bind -n M-l select-pane -R

          # Toggle pane zoom/fullscreen with Alt+f
          bind -n M-f resize-pane -Z

          # Resize panes
          bind -n M-Left resize-pane -L
          bind -n M-Down resize-pane -D
          bind -n M-Up resize-pane -U
          bind -n M-Right resize-pane -R

          # Switch windows with alt+number
          bind -n M-1 select-window -t 1
          bind -n M-2 select-window -t 2
          bind -n M-3 select-window -t 3
          bind -n M-4 select-window -t 4
          bind -n M-5 select-window -t 5
          bind -n M-6 select-window -t 6
          bind -n M-7 select-window -t 7
          bind -n M-8 select-window -t 8
          bind -n M-9 select-window -t 9

          # Switch sessions with prefix+number
          bind 1 attach-session -t 1
          bind 2 attach-session -t 2
          bind 3 attach-session -t 3
          bind 4 attach-session -t 4
          bind 5 attach-session -t 5
          bind 6 attach-session -t 6
          bind 7 attach-session -t 7
          bind 8 attach-session -t 8
          bind 9 attach-session -t 9

       bind -n M-c copy-mode

          # Use peasant standard vim keys for copy mode
          bind -T copy-mode j send -X cursor-down
          bind -T copy-mode l send -X cursor-right
          bind -T copy-mode h send -X cursor-left
          bind -T copy-mode k send -X cursor-up
          bind -T copy-mode J send -X -N 12 scroll-down
          bind -T copy-mode L send -X end-of-line
          bind -T copy-mode H send -X start-of-line
          bind -T copy-mode K send -X -N 12 scroll-up

          # Don't exit copy mode after selecting something with the mouse
          unbind -T copy-mode MouseDragEnd1Pane

          bind -T copy-mode v     send -X begin-selection
          bind -T copy-mode 'C-v' send -X begin-selection \; send -X rectangle-toggle
          bind -T copy-mode V     send -X select-line
          bind -T copy-mode r     send -X rectangle-toggle
          bind -T copy-mode y     send -X copy-pipe-and-cancel "xclip -in -selection clipboard"

          ########################################################
          # Powerline style statusbar with dynamic colors
          ########################################################

          %hidden c_red=${currentTheme.base08}
          %hidden c_green=${currentTheme.base0B}
          %hidden c_yellow=${currentTheme.base0A}
          %hidden c_orange=${currentTheme.base09}
          %hidden c_blue=${currentTheme.base0D}
          %hidden c_purple=${currentTheme.base0E}
          %hidden c_teal=${currentTheme.base0C}
          %hidden c_gray=${currentTheme.base05}
          %hidden c_gray2=${currentTheme.base04}
          %hidden c_fg=${currentTheme.base05}
          %hidden c_bg=${currentTheme.base00}
          %hidden c_text=${currentTheme.base06}
          %hidden c_primary=${currentTheme.base0D}

      # Status Bar Configuration
      set-option -g status-position top  # Position status bar at the top
      set -g status-style bg=default
      set -g status-left-length 200
      set -g status-right-length 200
      set -g window-status-separator ""

      # Disable session name on the left side
      set -g status-left ""  # No session name

      # Status right with session name and current working directory
      set -g status-right "#[fg=colour5,bg=default]#[fg=colour0,bg=colour5] #[fg=colour14,bg=colour0]#[fg=colour15,bg=colour0] #(echo \"#{pane_current_path}\" | awk -F/ '{ if (NF<=2) print \$NF; else print \$(NF-1)\"/\"\$NF; }') #[fg=colour0,bg=default] #[fg=colour14,bg=default]#[fg=colour0,bg=colour14] #[fg=colour14,bg=colour0]#[fg=colour15,bg=colour0] #S#[fg=colour0,bg=default] #[fg=colour14,bg=default]#[fg=colour0,bg=colour14]󰁹 #[fg=colour15,bg=colour0] #(battery-status)#[fg=colour0,bg=default]"

      # Window Status Formatting
      set -g window-status-format "#[fg=colour15,bg=default] #W #[fg=colour15,bg=colour8] #I#[fg=colour8,bg=default]"
      set -g window-status-current-format "#[fg=colour15,bg=default] #W #[fg=colour0,bg=colour12] #I#[fg=colour12,bg=default]"

      # Add gap between bar and content
      set -g 'status-format[1]' ""
      set -g status 2  # Status updates every 2 seconds

      set -g pane-border-style fg=colour8   # Inactive pane border color (dark grey)
      set -g pane-active-border-style fg=colour12  # Active pane border color (light blue, or any other color)

      set -sa terminal-features ",alacritty:RGB"
      set -sa terminal-overrides ",alacritty:RGB"
      set -as terminal-overrides ",*:Tc"
    '';
  };
}
