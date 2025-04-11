{
  programs.bash = {
    initExtra = ''
      # Apply inputrc settings via bind commands
      bind 'set colored-stats On'
      bind 'set colored-completion-prefix On'
      bind 'set show-all-if-ambiguous on'
      bind 'set completion-ignore-case on'
      bind 'set echo-control-characters off'

      # Key bindings
      bind '"\e[A": history-search-backward'
      bind '"\e[B": history-search-forward'
      bind '"\e[1;5D": backward-word'
      bind '"\e[1;5C": forward-word'
      bind '"\C-f": "cd ~/.config/\n"'
      bind '"\C-b": "cd ..\n"'
      bind '"\C-h": "cd\n"'
      bind '"\C-w": "webserver\n"'
      bind '"\es": "\C-asudo \C-e"'
    '';
  };
}
