#!/bin/bash

# Idle timeout in seconds
DIM_TIMEOUT=300     # 5 minutes
WARN_BATTERY=20     # warn at 20%

# Brightness levels
NORMAL_BRIGHTNESS=100
DIM_BRIGHTNESS=1       # almost black (simulate screen off)

# Function to get idle time in seconds
idle_time() {
    xprintidle | awk '{print int($1/1000)}'
}

# Function to get battery percentage
battery_level() {
    acpi -b | awk -F'[,:%]' '{print $2}'
}

while true; do
    idle=$(idle_time)
    bat=$(battery_level)

    # Dim screen after idle
    if [ "$idle" -ge "$DIM_TIMEOUT" ]; then
        xbacklight -set $DIM_BRIGHTNESS
    else
        xbacklight -set $NORMAL_BRIGHTNESS
    fi

    # Warn about low battery
    if [ "$bat" -le "$WARN_BATTERY" ]; then
        notify-send "Battery low" "$bat% remaining" -u critical
    fi

    sleep 5
done
