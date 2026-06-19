#!/usr/bin/env bash
# dashboard-launch.sh — launch the dashboard in a tmux split
# Put this in ~/.local/bin/ alongside dashboard.sh
# Hyprland keybind: kitty --class dashboard -e bash -c "~/.local/bin/dashboard-launch.sh"

SESSION="dashboard"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STATS_SCRIPT="$SCRIPT_DIR/dashboard.sh"

# Kill any existing dashboard session cleanly
tmux kill-session -t "$SESSION" 2>/dev/null

# Create session, left pane: stats loop
tmux new-session -d -s "$SESSION" -x "$(tput cols)" -y "$(tput lines)"
tmux send-keys -t "$SESSION" "bash '$STATS_SCRIPT'" Enter

# Right pane: calcurse (vertical split, 55% width for calcurse)
tmux split-window -t "$SESSION" -h -p 55
tmux send-keys -t "$SESSION" "calcurse" Enter

# Bind q in both panes to kill the whole session
# (calcurse has its own q, this handles the stats pane)
tmux bind-key -T root q run-shell "tmux kill-session -t $SESSION"

# Remove the status bar — this is a dashboard, not a dev session
tmux set-option -t "$SESSION" status off

# Focus the calcurse pane so it's ready to use immediately
tmux select-pane -t "$SESSION:0.1"

# Attach
tmux attach-session -t "$SESSION"
