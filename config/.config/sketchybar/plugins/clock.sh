#!/usr/bin/env bash

CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}"
source "$CONFIG_DIR/colors.sh"

TIME=$(date "+%I:%M %p")
DATE=$(date "+%a %d %b")
LABEL="$TIME  $DATE"

sketchybar --set "$NAME" \
    label="$LABEL" \
    icon="󰅐" \
    icon.color=$FG \
    icon.font="SF Pro:Semibold:15.0" \
    icon.y_offset=1 \
    label.color=$FG \
    label.font="Fira Sans:Medium:12.0" \
    label.y_offset=1
