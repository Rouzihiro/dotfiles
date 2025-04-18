{pkgs, ...}: let
  inherit (import ../../nixos/modules/variables.nix) shell;
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
            # Terminal Settings
            set -g default-terminal "tmux-256color"
            set -ga terminal-overrides ",foot*:Tc,foot:RGB,xterm-256color:RGB"
            set -g escape-time 0

            # Pane spawning keeps current working dir
            bind -n M-n new-window -c "#{pane_current_path}"
            bind -n M-s split-window -c "#{pane_current_path}"
            bind -n M-v split-window -h -c "#{pane_current_path}"
            bind g display-popup -B -d "#{pane_current_path}" -xC -yC -w100% -h100% -E 'lazygit'

            # Kill pane quickly
            bind -n M-q kill-pane

            # Move panes around
            bind -n M-h select-pane -L
            bind -n M-j select-pane -D
            bind -n M-k select-pane -U
            bind -n M-l select-pane -R

            # Zoom toggle
            bind -n M-f resize-pane -Z

            # Resize panes
            bind -n M-Left resize-pane -L
            bind -n M-Down resize-pane -D
            bind -n M-Up resize-pane -U
            bind -n M-Right resize-pane -R

            # Alt+num to switch windows
            ${builtins.concatStringsSep "\n" (builtins.genList (i: ''
          bind -n M-${toString (i + 1)} select-window -t ${toString (i + 1)}
        '')
        9)}

            # Prefix+num to attach to sessions
            ${builtins.concatStringsSep "\n" (builtins.genList (i: ''
          bind ${toString (i + 1)} attach-session -t ${toString (i + 1)}
        '')
        9)}

            # Copy-mode and mouse behavior
            bind -n M-c copy-mode
            unbind -T copy-mode MouseDragEnd1Pane
            bind -T copy-mode j send -X cursor-down
            bind -T copy-mode k send -X cursor-up
            bind -T copy-mode h send -X cursor-left
            bind -T copy-mode l send -X cursor-right
            bind -T copy-mode J send -X -N 12 scroll-down
            bind -T copy-mode K send -X -N 12 scroll-up
            bind -T copy-mode L send -X end-of-line
            bind -T copy-mode H send -X start-of-line
            bind -T copy-mode v send -X begin-selection
            bind -T copy-mode 'C-v' send -X begin-selection \; send -X rectangle-toggle
            bind -T copy-mode V send -X select-line
            bind -T copy-mode r send -X rectangle-toggle
            bind -T copy-mode y send -X copy-pipe-and-cancel "wl-copy"

            # Status Bar
            set -g status-position top
            set -g status-style bg=default
            set -g status-bg default
            set -g pane-active-border-style "fg=#5E81AC"
            set -g pane-border-style "fg=#4C566A"
            set -g status-left-length 40
            set -g status-right-length 200
            set -g status-interval 5


      # Left bar (no session name, optional decorative capsule)
      set -g status-left "#[fg=#3B4252,bg=default]#[fg=#D8DEE9,bg=#3B4252]  #[fg=#3B4252,bg=default]"

      # Capsule-style window tabs
      set -g window-status-separator " "
      set -g window-status-format "#[fg=#3B4252,bg=default]#[fg=#D8DEE9,bg=#3B4252] #I:#W #[fg=#3B4252,bg=default]"
      set -g window-status-current-format "#[fg=#33658A,bg=default]#[fg=#ECEFF4,bg=#33658A] #I:#W #[fg=#33658A,bg=default]"

      # Right Starship-style status
      set -g status-right "\
      #[fg=#434C5E,bg=default]\
      #[fg=#D8DEE9,bg=#434C5E]   #(echo \"#{pane_current_path}\" | awk -F/ '{ if (NF<=2) print \$NF; else print \$(NF-1)\"/\"\$NF; }') \
      #[fg=#434C5E,bg=#4C566A]#[fg=#D8DEE9,bg=#4C566A]  \
      #[fg=#4C566A,bg=#5E81AC]#[fg=#ECEFF4,bg=#5E81AC] #(battery-status | awk '/charging/ {print \"󰂂 \" \$2; next} {print \$2}') \
      #[fg=#5E81AC,bg=#86BBD8]#[fg=#86BBD8,bg=#06969A]#[fg=#06969A,bg=#33658A]\
      #[fg=#ECEFF4,bg=#33658A]  %H:%M \
      #[fg=#33658A,bg=default]"

    '';
  };
}
