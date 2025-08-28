# ~/Pictures/lockscreen/lock_scaled.png
#!/bin/sh
while true; do
    idle_time=$(xprintidle)
    if [ "$idle_time" -gt 300000 ]; then
        env XSECURELOCK_SAVER=saver_blank xsecurelock
    fi
    sleep 30
done
