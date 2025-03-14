{ pkgs }:
pkgs.writeShellScriptBin "keybinds-list-fish" ''
  #!/bin/sh

  # Extract aliases from fish.nix
  aliases=$(grep '^[[:space:]]*[a-zA-Z0-9_-]\+ =' ~/dotfiles/home/programs/fish.nix |
    sed -E 's/^[[:space:]]*([a-zA-Z0-9_-]+) = "(.*)";/\1 = \2/')

  # Escape ampersands in the aliases to avoid markup parsing errors in wofi
  aliases=$(echo "$aliases" | sed 's/&/&amp;/g')

  # If aliases exist, show them in wofi
  if [ -n "$aliases" ]; then
    echo "$aliases" | wofi --dmenu --prompt "Fish Aliases:" --width 800 --height 400
  else
    notify-send "No aliases found in fish.nix"
  fi
''

