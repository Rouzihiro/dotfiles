{pkgs}:
pkgs.writeScriptBin "rey-doc" ''
  SESSION_NAME="docs"

  tmux has-session -t $SESSION_NAME || {
      export DOCS_DIRECTORY="$HOME/dotfiles/home/docs"

      # Create session and first window
      tmux new-session -d -s $SESSION_NAME -c "$DOCS_DIRECTORY" -n "Main"
      
      # Main window: LF (top 80%) and terminal (bottom 20%)
      tmux send-keys -t $SESSION_NAME:0.0 'lf' C-m
      tmux split-window -v -t $SESSION_NAME:0.0
      tmux resize-pane -t $SESSION_NAME:0.0 -U 20
      tmux send-keys -t $SESSION_NAME:0.1 "cd $DOCS_DIRECTORY" C-m

      # Tasks window with 70/30 split
      tmux new-window -t $SESSION_NAME:1 -c "$DOCS_DIRECTORY/tasks" -n "Tasks"
      tmux split-window -h -l 70% -t $SESSION_NAME:1.0
      tmux send-keys -t $SESSION_NAME:1.0 'lf' C-m       # Left pane (70%)
      tmux send-keys -t $SESSION_NAME:1.1 'nvim tasks.MD' C-m  # Right pane (30%)

      # Final setup
      tmux select-window -t $SESSION_NAME:0
      tmux attach-session -t $SESSION_NAME
  } || tmux attach-session -t $SESSION_NAME
''
