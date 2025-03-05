{pkgs}:
pkgs.writeShellScriptBin "power-menu-sway" ''
  #!/bin/sh

  # Define actions
  suspend="systemctl suspend && swaylock -i ~/Pictures/lockscreen/lock.png"
  logout="swaymsg exit"
  reload="swaymsg reload"

  # Display the power menu
  chosen=$(printf "Log Out\nSuspend\nRestart\nPower OFF\nReload Sway" | wofi --dmenu -p "menu:")

  # Perform the selected action
  case "$chosen" in
      "Log Out") $logout ;;
      "Suspend") eval $suspend ;;
      "Restart") systemctl reboot ;;
      "Power OFF") systemctl poweroff ;;
      "Reload Sway") $reload ;;
      *) exit 1 ;;
  esac
''
