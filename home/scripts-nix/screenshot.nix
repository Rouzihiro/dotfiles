{pkgs}:
pkgs.writeShellScriptBin "screenshot" ''
  #!/bin/sh

  USAGE() {
      cat <<USAGE
  Usage: screenshot [option]
  Options:
    p     Print all outputs (save to file)
    pc    Print all outputs and copy to clipboard
    s     Select area or window to screenshot (save to file)
    sc    Select area or window and copy to clipboard
    m     Screenshot focused monitor (save to file)
    mc    Screenshot focused monitor and copy to clipboard
  USAGE
  }

  # Set default screenshot directory
  if [ -z "$XDG_SCREENSHOTS_DIR" ]; then
      XDG_SCREENSHOTS_DIR="$HOME/Pictures/screenshots"
  fi

  # Create the directory if it doesn't exist
  mkdir -p "$XDG_SCREENSHOTS_DIR"

  # Set the filename for the screenshot
  save_file=$(date +'%y%m%d_%Hh%Mm%Ss_screenshot.png')
  temp_screenshot="/tmp/screenshot.png"

  # Use Swappy as the annotation tool
  annotation_tool="${pkgs.swappy}/bin/swappy"
  annotation_args=("-o" "$XDG_SCREENSHOTS_DIR/$save_file" "-f" "$temp_screenshot")

  # Configure Swappy (optional)
  swappy_config="$HOME/.config/swappy/config"
  mkdir -p "$(dirname "$swappy_config")"
  echo -e "[Default]\nsave_dir=$XDG_SCREENSHOTS_DIR\nsave_filename_format=$save_file" > "$swappy_config"

  # Handle the screenshot based on the option
  case "$1" in
      p) # Print all outputs (save to file)
          ${pkgs.grim}/bin/grim "$temp_screenshot"
          "$annotation_tool" "''${annotation_args[@]}"
          ;;
      pc) # Print all outputs and copy to clipboard
          ${pkgs.grim}/bin/grim - | ${pkgs.wl-clipboard}/bin/wl-copy
          echo "Screenshot copied to clipboard."
          ;;
      s) # Select area or window to screenshot (save to file)
          geometry=$(${pkgs.slurp}/bin/slurp)
          if [ -z "$geometry" ]; then
              echo "Selection canceled."
              exit 1
          fi
          ${pkgs.grim}/bin/grim -g "$geometry" "$temp_screenshot"
          "$annotation_tool" "''${annotation_args[@]}"
          ;;
      sc) # Select area or window and copy to clipboard
          geometry=$(${pkgs.slurp}/bin/slurp)
          if [ -z "$geometry" ]; then
              echo "Selection canceled."
              exit 1
          fi
          ${pkgs.grim}/bin/grim -g "$geometry" - | ${pkgs.wl-clipboard}/bin/wl-copy
          echo "Screenshot copied to clipboard."
          ;;
      m) # Screenshot focused monitor (save to file)
          output=$(${pkgs.sway}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name')
          if [ -z "$output" ]; then
              echo "Failed to detect focused monitor."
              exit 1
          fi
          ${pkgs.grim}/bin/grim -o "$output" "$temp_screenshot"
          "$annotation_tool" "''${annotation_args[@]}"
          ;;
      mc) # Screenshot focused monitor and copy to clipboard
          output=$(${pkgs.sway}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name')
          if [ -z "$output" ]; then
              echo "Failed to detect focused monitor."
              exit 1
          fi
          ${pkgs.grim}/bin/grim -o "$output" - | ${pkgs.wl-clipboard}/bin/wl-copy
          echo "Screenshot copied to clipboard."
          ;;
      *) # Invalid option
          USAGE
          exit 1
          ;;
  esac

  # Clean up the temporary screenshot (if it exists)
  if [ -f "$temp_screenshot" ]; then
      rm "$temp_screenshot"
  fi
''
