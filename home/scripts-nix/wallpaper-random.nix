{pkgs}:
pkgs.writeShellScriptBin "wallpaper-random" ''
  #!/bin/sh

  # Path to your wallpapers folder
  wallpaper_folder="''${HOME}/Pictures/wallpapers"

  # Check directory exists
  if [ ! -d "$wallpaper_folder" ]; then
      echo "Error: Wallpaper directory not found" >&2
      exit 1
  fi

  # Check for files
  shopt -s nullglob
  files=("$wallpaper_folder"/*)
  if [ ''${#files[@]} -eq 0 ]; then
      echo "Error: No files found in wallpaper directory" >&2
      exit 1
  fi

  # Select random file
  selected_file=''${files[RANDOM % ''${#files[@]}]}

  # Set wallpaper
  ${pkgs.swww}/bin/swww init 2>/dev/null
  ${pkgs.swww}/bin/swww img "$selected_file" \
    --transition-type grow \
    --transition-pos 0.5,0.5 \
    --transition-duration 2 \
    --transition-fps 60
''
