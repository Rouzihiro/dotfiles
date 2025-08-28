#!/bin/sh
# Autolock daemon script
# Idle lock after 5 minutes

while true; do
    idle_time=$(xprintidle)  # milliseconds
    if [ "$idle_time" -gt 300000 ]; then
        # This calls your simple lock command
        i3lock --color 000000 --nofork
				# i3lock --image ~/Pictures/lockscreen/lock_scaled.png --nofork
    fi
    sleep 30
done
