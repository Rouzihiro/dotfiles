#!/bin/sh
while true; do
    idle_time=$(xprintidle)
    if [ "$idle_time" -gt 300000 ]; then
        # Simple blank screen (safe default)
        # env XSECURELOCK_SAVER=saver_blank xsecurelock
        # With your custom image (uncomment to use later)
        env XSECURELOCK_SAVER=saver_image XSECURELOCK_IMAGE_PATH=~/Pictures/lockscreen/lock.png XSECURELOCK_IMAGE_SCALING=fit xsecurelock
    fi
    sleep 30
done
