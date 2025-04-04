{ pkgs }:
pkgs.writeShellScriptBin "keybinds-list-sway" ''
  #!/bin/sh

  # Check if wofi is already running
  if pidof wofi > /dev/null; then
    pkill wofi
  fi

  # Extract keybinds from Sway config, ignoring the first 18 lines
  keybinds=$(tail -n +19 ~/.config/sway/config | grep 'bindsym' | sed 's/bindsym //')

  # Escape special characters (like &) for wofi
  keybinds_escaped=$(echo "$keybinds" | sed 's/&/&amp;/g')

  # Use wofi to display the keybinds with a larger window size
  echo "$keybinds_escaped" | wofi --dmenu --prompt "Keybinds:" --height 400 --width 800
''
