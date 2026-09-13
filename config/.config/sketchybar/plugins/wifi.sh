#!/usr/bin/env bash
CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}"
source "$CONFIG_DIR/colors.sh"

SSID=$(ipconfig getsummary en0 2>/dev/null | awk -F': ' '/^ *SSID :/{print $2}')

if [[ -z "$SSID" ]]; then
    sketchybar --set "$NAME" \
        icon="󰤭" \
        icon.color=$FG_FAINT \
        label="Disconnected" \
        _FAINT
    exit 0
fi

# Use system_profiler for RSSI — run async, cache result
CACHE="${TMPDIR:-/tmp}/sketchybar_wifi_rssi"
if [[ ! -f "$CACHE" ]] || [[ $(( $(date +%s) - $(stat -f %m "$CACHE") )) -gt 30 ]]; then
    system_profiler SPAirPortDataType 2>/dev/null | \
        awk '/Current Network Information/{found=1} found && /Signal/{print $3; exit}' > "$CACHE" &
fi

RSSI=$(cat "$CACHE" 2>/dev/null)

if [[ -z "$RSSI" ]]; then
    ICON="󰤨"; COLOR=$FG
elif [[ $RSSI -ge -50 ]]; then
    ICON="󰤨"; COLOR=$SUCCESS
elif [[ $RSSI -ge -65 ]]; then
    ICON="󰤥"; COLOR=$SUCCESS
elif [[ $RSSI -ge -75 ]]; then
    ICON="󰤢"; COLOR=$WARNING
else
    ICON="󰤟"; COLOR=$ERROR
fi

sketchybar --set "$NAME" \
    icon="$ICON" \
    icon.color=$COLOR \
    label.drawing=off \
