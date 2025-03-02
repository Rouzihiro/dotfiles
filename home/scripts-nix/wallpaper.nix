{pkgs}:
pkgs.writeShellScriptBin "wallpaper" ''
  #!/bin/sh

  # Directory containing static wallpapers
  wallpaper_folder="''${HOME}/Pictures/wallpapers"

  # Get list of static wallpapers
  files=$(find -L "$wallpaper_folder" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.gif" \))
  if [ -z "$files" ]; then
      echo "No wallpapers found in $wallpaper_folder"
      exit 1
  fi

  # Display selection menu with Wofi
  selected_file=$(echo "$files" | xargs -I{} basename {} | ${pkgs.wofi}/bin/wofi --dmenu -i -p "Select Wallpaper")
  if [ -z "$selected_file" ]; then
      echo "No wallpaper selected. Exiting."
      exit 0
  fi

  # Find full path of selected file
  selected_file=$(find -L "$wallpaper_folder" -type f -name "$selected_file")

  # Set wallpaper with swww animation
  ${pkgs.swww}/bin/swww init 2>/dev/null  # Initialize if not already running
  ${pkgs.swww}/bin/swww img "$selected_file" \
      --transition-type grow \
      --transition-pos 0.5,0.5 \
      --transition-duration 2 \
      --transition-fps 60
''
