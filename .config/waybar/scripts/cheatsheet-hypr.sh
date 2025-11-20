#!/bin/bash

pkill yad || true

# Check if rofi is already running
if pidof rofi > /dev/null; then
  pkill rofi
fi

# Define the config files
KEYBINDS_CONF="$HOME/.config/hypr/components/binds.conf"

# Combine the contents of the keybinds files and filter for keybinds
KEYBINDS=$(grep -E '^(bind|bindl|binde|bindm)' "$KEYBINDS_CONF" \
  | awk -F'#' '{
      # Extract keybind part and comment
      keybind = $1
      comment = $2

      # Remove bind prefix
      gsub(/^bind[a-z]* = /, "", keybind)
      gsub(/^hyprexpo:expo[a-z]* = /, "", keybind)
      # Replace $mainMod with 
      gsub(/\$mainMod/, "", keybind)

      # Split by comma and extract keys only (skip command)
      split(keybind, parts, ",")
      keys = ""
      for (i = 1; i <= length(parts); i++) {
        gsub(/^ +| +$/, "", parts[i])
        # Stop when we hit exec or command-like part
        if (parts[i] ~ /^exec/ || parts[i] ~ /^[a-z]+$/ && i > 2) {
          break
        }
        if (parts[i] != "") {
          if (keys != "") keys = keys " + "
          keys = keys parts[i]
        }
      }

      # Replace key names with nerd icons
      gsub(/CTRL/, "󰘴", keys)
      gsub(/SHIFT/, "󰘶", keys)
      gsub(/SPACE/, "󱁐", keys)
      gsub(/hyprexpo:expo/, "", keys)
      gsub(/overview:toggle/, "", keys)
      gsub(/mouse:272/, "LMB", keys)
      gsub(/mouse:273/, "RMB", keys)

      # Clean up spaces around +
      gsub(/ +\+/, " +", keys)
      gsub(/\+ +/, "+ ", keys)
      gsub(/^ +| +$/, "", keys)
      gsub(/ +/, " ", keys)
      # Remove empty + combinations
      gsub(/ \+ \+/, " +", keys)
      gsub(/^\+ /, "", keys)
      gsub(/ \+$/, "", keys)

      # Print formatted output
      if (comment != "") {
        gsub(/^ +| +$/, "", comment)
        print comment " | " keys
      }
    }')


# check for any keybinds to display
if [[ -z "$KEYBINDS" ]]; then
    echo "No keybinds found."
    exit 1
fi

# Use rofi to display the keybinds
echo "$KEYBINDS" | rofi -matching fuzzy -dmenu -i -p " Cheat Sheet" -theme "$HOME/.config/rofi/cheatsheet.rasi"
