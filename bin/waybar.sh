#!/bin/bash

if pgrep -x "hyprland" > /dev/null; then
  export WM_NAME="hyprland"
elif pgrep -x "sway" > /dev/null; then
  export WM_NAME="sway"
elif pgrep -x "river" > /dev/null; then
  export WM_NAME="river"
fi

# Start Waybar
waybar

