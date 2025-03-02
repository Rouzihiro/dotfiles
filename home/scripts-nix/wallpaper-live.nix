{pkgs}:
pkgs.writeShellScriptBin "wallpaper-live" ''
  #!/bin/sh

  # Prompt user to choose wallpaper type
  choice=$(echo -e "Static Wallpaper\nLive Wallpaper" | ${pkgs.wofi}/bin/wofi --dmenu -i -p "Choose Wallpaper Type")
  if [ -z "$choice" ]; then
      echo "No choice selected. Keeping the current wallpaper."
      exit 0
  fi

  # Function to set static wallpaper
  set_static_wallpaper() {
      # Kill `mpvpaper` to ensure no live wallpaper is running
      pkill mpvpaper

      # Directory containing static wallpapers
      wallpaper_folder="''${HOME}/Pictures/wallpapers"

      # Get a list of static wallpapers
      files=$(find -L "$wallpaper_folder" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.gif" \))
      if [ -z "$files" ]; then
          echo "No static wallpapers found in $wallpaper_folder"
          exit 1
      fi

      # Display selection menu with Wofi
      selected_file=$(echo "$files" | xargs -I{} basename {} | wofi --dmenu -i -p "Select Static Wallpaper")
      if [ -z "$selected_file" ]; then
          echo "No wallpaper selected. Keeping current."
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
  }

  # Function to set live wallpaper
  set_live_wallpaper() {
      # Kill swww daemon
      ${pkgs.swww}/bin/swww kill

      # Directories containing live wallpapers
      wallpaper_folders=(
          "''${HOME}/Videos/wallpaper-live"
          "''${HOME}/dotfiles/home/pictures/wallpaper-live"
      )

      # Get list of live wallpapers
      files=$(find -L "''${wallpaper_folders[@]}" -type f \( -iname "*.mp4" -o -iname "*.mkv" -o -iname "*.webm" \))
      if [ -z "$files" ]; then
          echo "No live wallpapers found."
          exit 1
      fi

      # Display selection menu with Wofi
      selected_file=$(echo "$files" | xargs -I{} basename {} | wofi --dmenu -i -p "Select Live Wallpaper")
      if [ -z "$selected_file" ]; then
          echo "No live wallpaper selected. Keeping current."
          exit 0
      fi

      # Find full path of selected file
      selected_file=$(find -L "''${wallpaper_folders[@]}" -type f -name "$selected_file")

      # Start mpvpaper
      output="HDMI-A-1"  # Replace with your output name
      pkill mpvpaper
      ${pkgs.mpvpaper}/bin/mpvpaper -o "no-audio loop" "$output" "$selected_file"
  }

  # Execute choice
  if [ "$choice" = "Static Wallpaper" ]; then
      set_static_wallpaper
  elif [ "$choice" = "Live Wallpaper" ]; then
      set_live_wallpaper
  else
      echo "Invalid choice. Exiting."
      exit 1
  fi
''
