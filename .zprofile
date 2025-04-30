# Start a dbus session if it's not already running
#if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
#    eval "$(dbus-launch --sh-syntax)"
#fi

# Start Hyprland (only if this is a TTY session, e.g., TTY1)
#if [[ -z $DISPLAY && $(tty) = /dev/tty1 ]]; then
#    exec Hyprland
#fi

if uwsm check may-start && uwsm select; then
exec uwsm start Hyprland
  fi
