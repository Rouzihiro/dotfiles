#!/usr/bin/env bash

CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}"
source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"

if [ "$SENDER" = "front_app_switched" ]; then
    APP_NAME="$INFO"
else
    APP_NAME=$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true' 2>/dev/null || echo "Unknown")
fi

sketchybar --set "$NAME" \
    icon.drawing=off \
    label="$APP_NAME" \
    label.color=$FG_DIM \
    label.font="Fira Sans:Medium:12.0" \
    label.y_offset=0
