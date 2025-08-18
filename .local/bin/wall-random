#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/Pictures/wallpapers"
SWAYBG_PID_FILE="$XDG_RUNTIME_DIR/swaybg.pid"
WALLPAPER_CACHE="$HOME/.cache/wallpaper"

# Get random wallpaper (excluding directories)
wallpaper=$(find -L "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.webp" \) | shuf -n 1)

# Exit if no wallpapers found
[[ -z "$wallpaper" ]] && { echo "No wallpapers found in $WALLPAPER_DIR"; exit 1; }

# Kill previous swaybg instance
if [[ -f "$SWAYBG_PID_FILE" ]]; then
    kill "$(cat "$SWAYBG_PID_FILE")" 2>/dev/null
fi

# Set new wallpaper
swaybg -i "$wallpaper" -m fill &
echo $! > "$SWAYBG_PID_FILE"
echo "$wallpaper" > "$WALLPAPER_CACHE"
