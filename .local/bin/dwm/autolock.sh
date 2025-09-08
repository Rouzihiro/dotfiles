#!/bin/bash

LOCK_TIMEOUT=2400   # 40 minutes

while true; do
    idle=$(xprintidle)
    idle_sec=$((idle / 1000))

    if [ "$idle_sec" -ge "$LOCK_TIMEOUT" ]; then
        # Lock only if not already locked
        pgrep -x i3lock >/dev/null || i3lock -i ~/Pictures/lockscreen/lock_scaled.png
    fi

    sleep 5
done
