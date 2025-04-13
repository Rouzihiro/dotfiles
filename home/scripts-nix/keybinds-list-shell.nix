{ pkgs }:
pkgs.writeShellScriptBin "keybinds-list-shell" ''
  #!/bin/sh

  # Extract aliases from bash.nix
  aliases=$(grep '^[[:space:]]*[a-zA-Z0-9_-]\+ =' ~/dotfiles/home/programs/bash.nix |
    sed -E 's/^[[:space:]]*([a-zA-Z0-9_-]+) = "(.*)";/\1 = \2/')

  # Escape ampersands in the aliases to avoid markup parsing errors in wofi
  aliases=$(echo "$aliases" | sed 's/&/&amp;/g')

  # If aliases exist, show them in wofi
  if [ -n "$aliases" ]; then
    echo "$aliases" | wofi --dmenu --prompt "Bash Aliases:" --width 800 --height 400
  else
    notify-send "No aliases found in bash.nix"
  fi
''

