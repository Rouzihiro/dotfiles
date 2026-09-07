#!/usr/bin/env bash
CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}"
source "$CONFIG_DIR/colors.sh"

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --animate tanh 10 --set "$NAME" \
        icon.color=$WS_ACTIVE_FG \
        label.color=$WS_ACTIVE_FG \
        background.color=$WS_ACTIVE_BG \
        background.border_color=$WS_ACTIVE_BORDER
else
    sketchybar --animate tanh 10 --set "$NAME" \
        icon.color=$WS_INACTIVE_FG \
        label.color=$WS_INACTIVE_FG \
        background.color=$WS_INACTIVE_BG \
        background.border_color=$WS_INACTIVE_BORDER
fi
