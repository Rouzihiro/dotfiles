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
bind '"\C-f": "cd ~/.config/\n"'         # Ctrl + F → cd into ~/.config
bind '"\C-b": "cd ..\n"'                 # Ctrl + B → cd ..
bind '"\C-h": "cd\n"'                    # Ctrl + H → cd (home)
bind '"\C-d": "cd ~/Downloads && ls\n"'  # Ctrl + D → cd Downloads + ls
bind '"\C-m": "cd ~/Videos && ls\n"'     # Ctrl + M → cd Videos + ls
bind '"\C-r": "cd ~/dotfiles && ls\n"'   # Ctrl + R → cd dotfiles + ls


# Jump to common folders and list
bind '"\C-d": "cd ~/Downloads && ls\n"'  # Ctrl + D → cd Downloads + ls
bind '"\C-m": "cd ~/Videos && ls\n"'     # Ctrl + M → cd Videos + ls

# Quick command execution
bind '"\C-w": "webserver\n"'             # Ctrl + W → run `webserver` function

# Insert sudo at start of current line
bind '"\es": "\C-asudo \C-e"'            # Alt + S → sudo (beginning of line)

