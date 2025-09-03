#!/bin/bash

# Idle timeout in seconds
DIM_TIMEOUT=300     # 5 minutes
WARN_BATTERY=20     # warn at 20%

# Brightness levels
DIM_BRIGHTNESS=1    # almost black (simulate screen off)

# Function to get idle time in seconds
idle_time() {
    xprintidle | awk '{print int($1/1000)}'
}

# Function to get battery percentage
battery_level() {
    acpi -b | awk -F'[,:%]' '{print $2}'
}

# Track whether screen is currently dimmed
dimmed=false

while true; do
    idle=$(idle_time)
    bat=$(battery_level)

    if [ "$idle" -ge "$DIM_TIMEOUT" ]; then
        # If idle and not already dimmed, dim screen
        if [ "$dimmed" = false ]; then
            xbacklight -set $DIM_BRIGHTNESS
            dimmed=true
        fi
    else
        # If activity detected and screen is dimmed, restore last manual brightness
        if [ "$dimmed" = true ]; then
            # restore to user’s brightness (whatever it was before dim)
            xbacklight -set 100
            dimmed=false
        fi
    fi

    # Warn about low battery
    if [ "$bat" -le "$WARN_BATTERY" ]; then
        notify-send "Battery low" "$bat% remaining" -u critical
    fi

    sleep 5
done
