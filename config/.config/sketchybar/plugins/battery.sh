#!/usr/bin/env bash

CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}"
source "$CONFIG_DIR/colors.sh"

BATTERY_INFO=$(pmset -g batt | grep -Eo "[0-9]+%" | cut -d% -f1)
POWER_SOURCE=$(pmset -g ps | head -1)

if [[ $POWER_SOURCE == *"AC Power"* ]]; then
    CHARGING=true
else
    CHARGING=false
fi

BATTERY_LEVEL=$BATTERY_INFO

if [[ $CHARGING == true ]]; then
    ICON="󰂄"
    COLOR=$SUCCESS
else
    if [[ $BATTERY_LEVEL -gt 75 ]]; then
        ICON="󰁹"
        COLOR=$BATTERY_FULL
    elif [[ $BATTERY_LEVEL -gt 50 ]]; then
        ICON="󰁾"
        COLOR=$BATTERY_HIGH
    elif [[ $BATTERY_LEVEL -gt 25 ]]; then
        ICON="󰁼"
        COLOR=$BATTERY_MED
    elif [[ $BATTERY_LEVEL -gt 10 ]]; then
        ICON="󰁻"
        COLOR=$BATTERY_LOW
    else
        ICON="󰁺"
        COLOR=$BATTERY_CRITICAL
    fi
fi

sketchybar --set "$NAME" \
    icon="$ICON" \
    icon.color="$COLOR" \
    icon.font="SF Pro:Semibold:15.0" \
    icon.y_offset=1 \
    label="$BATTERY_LEVEL%" \
    label.color=$FG \
    label.font="Fira Sans:Medium:12.0" \
    label.y_offset=1
