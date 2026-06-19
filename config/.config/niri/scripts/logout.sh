#!/bin/bash

action=$(zenity --list \
  --title="System Power Options" \
  --text="Choose an action:" \
  --width=300 --height=180 \
  --column="Action" "Power Off" "Reboot" "Cancel")

case "$action" in
  "Power Off")
    if zenity --question --text="Are you sure you want to power off?" --width=250; then
      systemctl poweroff
    fi
    ;;
  "Reboot")
    if zenity --question --text="Are you sure you want to reboot?" --width=250; then
      systemctl reboot
    fi
    ;;
  "Cancel" | *)
    # Do nothing
    ;;
esac

