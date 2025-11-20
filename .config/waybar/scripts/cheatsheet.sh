#!/bin/bash

pkill yad || true

# Check if rofi is already running
if pidof rofi > /dev/null; then
  pkill rofi
fi

# Define the config files
KEYBINDS_CONF="$HOME/.config/sway/config.d/custom"

# Combine the contents of the keybinds files and filter for keybinds
KEYBINDS=$(grep -E '^bindsym' "$KEYBINDS_CONF" \
  | awk -F'#' '{
      # Extract keybind part and comment
      keybind = $1
      comment = $2

      # Remove bindsym prefix and clean up
      gsub(/^bindsym /, "", keybind)
      
      # Replace $mod with  and other variables
      gsub(/\$mod/, "", keybind)
      gsub(/\$term/, "term", keybind)
      gsub(/\$lockscreen/, "lock", keybind)
      
      # Split by exec or other commands to separate keys from action
      split(keybind, parts, " exec ")
      if (length(parts) < 2) {
        split(keybind, parts, " ")
      }
      
      keys = parts[1]
      action = parts[2]
      
      # Replace key names with nerd icons and clean up
      gsub(/mod1/, "Alt", keys)
      gsub(/Shift/, "󰘶", keys)
      gsub(/CTRL/, "󰘴", keys)
      gsub(/Control/, "󰘴", keys)
      gsub(/space/, "󱁐", keys)
      gsub(/grave/, "`", keys)
      gsub(/Escape/, "Esc", keys)
      
      # Clean up the action description
      if (action != "") {
        # Remove variable substitutions and simplify commands
        gsub(/\$[a-zA-Z_]+/, "", action)
        gsub(/^bm-/, "", action)
        gsub(/^wofi-/, "", action)
        gsub(/exec /, "", action)
        gsub(/^--app-id=runner_floating -e /, "", action)
        gsub(/^bash -c .*/, "system command", action)
        gsub(/^sh -c /, "", action)
        gsub(/^cd \/ && /, "", action)
        gsub(/^sudo /, "", action)
        
        # Shorten common patterns
        if (action ~ /^term/) action = "terminal app"
        if (action ~ /^floating/) action = "toggle floating"
        if (action ~ /^scratchpad/) action = "scratchpad"
      }
      
      # Use comment if available, otherwise use simplified action
      if (comment != "") {
        gsub(/^ +| +$/, "", comment)
        description = comment
      } else if (action != "") {
        description = action
        # Truncate long descriptions
        if (length(description) > 40) {
          description = substr(description, 1, 37) "..."
        }
      } else {
        description = "unknown action"
      }
      
      # Clean up keys formatting
      gsub(/\+/, " + ", keys)
      gsub(/  +/, " ", keys)
      gsub(/^ \+ | \+ $/, "", keys)
      
      # Print formatted output
      print description " | " keys
    }')

# Check for any keybinds to display
if [[ -z "$KEYBINDS" ]]; then
    echo "No keybinds found."
    exit 1
fi

# Use rofi to display the keybinds
echo "$KEYBINDS" | rofi -matching fuzzy -dmenu -i -p " Cheat Sheet" -theme "$HOME/.config/rofi/cheatsheet.rasi"
