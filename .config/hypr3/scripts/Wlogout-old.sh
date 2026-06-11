#!/bin/bash

action=$(zenity --list --title="System Power Options" --column="Action" "Power Off" "Reboot" "Cancel")

case "$action" in
  "Power Off")
    if zenity --question --text="Are you sure you want to power off?"; then
      systemctl poweroff
    fi
    ;;
  "Reboot")
    if zenity --question --text="Are you sure you want to reboot?"; then
      systemctl reboot
    fi
    ;;
  "Cancel" | *)
    # Do nothing or exit
    ;;
esac

