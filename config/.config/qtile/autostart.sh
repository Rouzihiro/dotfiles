#!/usr/bin/env bash

sleep 3

mako &
swww-daemon &
wl-paste -t text --watch clipman store --no-persist &

swayidle -w \
  before-sleep "swaylock -fF -i ~/Pictures/lockscreen/VIM.png" \
  timeout 300 'if ! pgrep -x "motrix"; then brightnessctl -s set 0; fi' \
  resume 'brightnessctl -r' &

pipewire &
pipewire-pulse &
wireplumber &
