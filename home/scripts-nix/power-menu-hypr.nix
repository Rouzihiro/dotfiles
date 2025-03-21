{pkgs}:
pkgs.writeShellScriptBin "power-menu-hypr" ''
  #!/bin/sh

  # Define actions
  suspend="systemctl suspend && hyprlock -i ~/Pictures/lockscreen/lock.png"
  logout="killall Hyprland"

  # Display the power menu
  chosen=$(printf "Log Out\nSuspend\nRestart\nPower OFF" | wofi --dmenu -p "menu:")

  # Perform the selected action
  case "$chosen" in
      "Log Out") $logout ;;
      "Suspend") eval $suspend ;;
      "Restart") systemctl reboot ;;
      "Power OFF") systemctl poweroff ;;
      *) exit 1 ;;
  esac
''
