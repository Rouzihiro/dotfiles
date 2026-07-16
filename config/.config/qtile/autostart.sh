#!/usr/bin/env bash

# Give Wayland/Qtile time to settle
sleep 3

# Notification daemon
mako &

# Network tray
# nm-applet &

# Wallpaper
swww-daemon &
