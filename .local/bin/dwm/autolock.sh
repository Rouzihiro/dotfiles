#!/usr/bin/env bash

IDLE_LIMIT=$((5*60*1000))  # 5 minutes in ms
LOCK_CMD="i3lock -i ~/Pictures/lockscreen/lock_scaled.png"

# Track last idle to avoid instant relock after suspend
last_idle=0

while true; do
    idle_time=$(xprintidle)

    # Only lock if idle AND not already locked
    if [ "$idle_time" -gt "$IDLE_LIMIT" ] && ! pgrep -x i3lock >/dev/null; then
        $LOCK_CMD
    fi

    # If idle time drops significantly (e.g., after suspend), reset last_idle
    if [ "$idle_time" -lt $((IDLE_LIMIT / 10)) ]; then
        last_idle=0
    fi

    sleep 10
done &
