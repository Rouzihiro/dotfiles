{pkgs}:
pkgs.writeShellScriptBin "monitor-multi" ''

  # Detect window manager/compositor
  detect_wm() {
      if [ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
          echo "hyprland"
      elif [ -n "$SWAYSOCK" ]; then
          echo "sway"
      elif pgrep -x "qtile" >/dev/null; then
          echo "qtile"
      elif pgrep -x "i3" >/dev/null; then
          echo "i3"
      else
          echo "unknown"
      fi
  }

  # Get output names (adapt these for your specific hardware)
  get_outputs() {
      case $WM in
          "hyprland") echo "eDP-1 HDMI-A-1" ;;  # Hyprland uses descriptive names
          "sway") echo "eDP-1 HDMI-A-1" ;;      # Same as sway
          "qtile") echo "eDP-1 HDMI-A-1" ;;     # May vary based on your setup
          "i3") echo "eDP1 HDMI1" ;;            # i3 typically uses simpler names
          *) echo "unknown" ;;
      esac
  }

  # Set commands based on detected WM
  WM=$(detect_wm)
  case $WM in
      "hyprland")
          CMD="hyprctl keyword monitor"
          ENABLE_SUFFIX=",preferred,auto,1"
          DISABLE_SUFFIX=",disable"
          ;;
      "sway")
          CMD="swaymsg output"
          ENABLE_SUFFIX=" enable"
          DISABLE_SUFFIX=" disable"
          ;;
      "qtile")
          CMD="wlr-randr --output"
          ENABLE_SUFFIX=" --on"
          DISABLE_SUFFIX=" --off"
          ;;
      "i3")
          CMD="i3-msg output"
          ENABLE_SUFFIX=" enable"
          DISABLE_SUFFIX=" disable"
          ;;
      *)
          echo "Unsupported window manager"
          exit 1
          ;;
  esac

  # Get outputs for current WM
  read -r INTERNAL EXTERNAL <<< "$(get_outputs)"

  # Command execution wrapper
  output_cmd() {
      local output=$1
      local action=$2
      case $action in
          enable) full_cmd="$CMD $output$ENABLE_SUFFIX" ;;
          disable) full_cmd="$CMD $output$DISABLE_SUFFIX" ;;
      esac
      eval "$full_cmd"
  }

  # Monitor configurations
  enable_external_only() {
      output_cmd "$INTERNAL" disable
      output_cmd "$EXTERNAL" enable
      echo "External only setup enabled."
  }

  enable_laptop_only() {
      output_cmd "$INTERNAL" enable
      output_cmd "$EXTERNAL" disable
      echo "Laptop only setup enabled."
  }

  enable_dual() {
      output_cmd "$INTERNAL" enable
      output_cmd "$EXTERNAL" enable
      echo "Dual monitor setup enabled."
  }

  # Check if wofi is available, else fallback to foot
  if command -v wofi >/dev/null 2>&1; then
      # Use wofi for selection
      choice=$(echo -e "External Only\nLaptop Only\nDual" | wofi --dmenu --prompt="Select monitor setup:")
  else
      # Fallback to foot terminal with a prompt
      choice=$(echo -e "External Only\nLaptop Only\nDual" | foot -d "Select monitor setup:")
  fi

  case "$choice" in
      "External Only") enable_external_only ;;
      "Laptop Only") enable_laptop_only ;;
      "Dual") enable_dual ;;
      *) echo "Invalid option"; exit 1 ;;
  esac
''
