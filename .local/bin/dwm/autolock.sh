#!/usr/bin/bash
# Idle lock after 5 minutes
(
    while true; do
        idle_time=$(xprintidle)  # milliseconds
        if [ "$idle_time" -gt 300000 ]; then
            i3lock -i ~/Pictures/lockscreen/lock_scaled.png
        fi
        sleep 30
    done
) &

