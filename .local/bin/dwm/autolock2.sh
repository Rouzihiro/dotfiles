#!/usr/bin/env bash

IDLE_LIMIT=$((5*60*1000))  # 5 minutes in ms
LOCK_CMD="i3lock -i ~/Pictures/lockscreen/lock_scaled.png"

while true; do
    idle_time=$(xprintidle)

    # Check for fullscreen windows
    fullscreen_count=$(xdotool search --onlyvisible --class "" getwindowfocus getwindowgeometry 2>/dev/null | grep -c "Geometry")

    # Only lock if idle, not already locked, and no fullscreen windows
    if [ "$idle_time" -gt "$IDLE_LIMIT" ] && ! pgrep -x i3lock >/dev/null && [ "$fullscreen_count" -eq 0 ]; then
        $LOCK_CMD
    fi

    sleep 10
done &
