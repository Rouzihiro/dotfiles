#!/bin/bash

read cpu user nice system idle iowait irq softirq steal guest < /proc/stat
total1=$((user + nice + system + idle + iowait + irq + softirq + steal))
idle1=$((idle + iowait))

sleep 0.5

read cpu user nice system idle iowait irq softirq steal guest < /proc/stat
total2=$((user + nice + system + idle + iowait + irq + softirq + steal))
idle2=$((idle + iowait))

total_diff=$((total2 - total1))
idle_diff=$((idle2 - idle1))

if (( total_diff == 0 )); then
    echo "0%"
    exit
fi

cpu_usage=$(( (100 * (total_diff - idle_diff)) / total_diff ))
echo "$cpu_usage%"

