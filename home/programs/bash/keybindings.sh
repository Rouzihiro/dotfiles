# Better colors and completion behavior
bind 'set colored-stats On'
bind 'set colored-completion-prefix On'
bind 'set show-all-if-ambiguous on'
bind 'set completion-ignore-case on'
bind 'set echo-control-characters off'

# Up/Down arrow search history by prefix
bind '"\e[A": history-search-backward'   # Up arrow
bind '"\e[B": history-search-forward'    # Down arrow

# Ctrl + Arrow keys: word navigation
bind '"\e[1;5D": backward-word'          # Ctrl + Left Arrow
bind '"\e[1;5C": forward-word'           # Ctrl + Right Arrow

# Quick directory jumps
bind '"\C-w": "cd ~/.config/\n"'         # Ctrl + W → cd into ~/.config
bind '"\C-b": "cd ..\n"'                 # Ctrl + B → cd ..
bind '"\C-f": "cd\n"'                    # Ctrl + F → cd (home)
bind '"\C-h":"zi\n"'										 # Ctrl + H → zi

# Quick command execution
#bind '"\C-w": "webserver\n"'             # Ctrl + W → run `webserver` function

# Insert sudo at start of current line
bind '"\es": "\C-asudo \C-e"'            # Alt + S → sudo (beginning of line)
