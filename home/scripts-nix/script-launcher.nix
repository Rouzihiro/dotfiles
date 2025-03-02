{pkgs}:
pkgs.writeShellScriptBin "script-launcher" ''
  #!/bin/sh

  # Predefined list of scripts
  static_scripts="
  bandwidth
  browse-video
  browse-web
  calendar
  extract-helper
  keybinds-shell
  keybinds-sway
  monitor-multi
  ocr
  ocr-prompt
  ocr-translate
  powersave
  time-zones
  weather
  wallpaper"

  # Dynamically find scripts in the directory
  dynamic_scripts=$(find ~/dotfiles/home/scripts -type f -print0 | xargs -0 -I{} basename "{}")

  # Combine both lists
  all_scripts=$(printf "%s\n%s" "$static_scripts" "$dynamic_scripts")

  # Use Wofi to select a script
  chosen=$(echo "$all_scripts" | sort | uniq | wofi --dmenu --prompt="Select a script:")

  # Execute the selected script
  if [ -n "$chosen" ]; then
      # Check if the chosen script is from the dynamic list
      if echo "$dynamic_scripts" | grep -q "^$chosen$"; then
          zsh ~/dotfiles/home/scripts/"$chosen"
      else
          $chosen
      fi
  fi
''
