#!/bin/bash

# Idle timeout in seconds
DIM_TIMEOUT=300     # 5 minutes
WARN_BATTERY=20     # warn at 20%

# Brightness level when idle
DIM_BRIGHTNESS=1    # almost black (simulate screen off)

# Function to get idle time in seconds
idle_time() {
    xprintidle | awk '{print int($1/1000)}'
}

# Function to get battery percentage
battery_level() {
    acpi -b | awk -F'[,:%]' '{print $2}'
}

# Track state
dimmed=false
prev_brightness=100

while true; do
    idle=$(idle_time)
    bat=$(battery_level)

    if [ "$idle" -ge "$DIM_TIMEOUT" ]; then
        # If idle and not already dimmed
        if [ "$dimmed" = false ]; then
            # Save current brightness before dimming
            prev_brightness=$(xbacklight -get | awk '{print int($1)}')
            xbacklight -set $DIM_BRIGHTNESS
            dimmed=true
        fi
    else
        # If activity detected and screen is dimmed
        if [ "$dimmed" = true ]; then
            xbacklight -set $prev_brightness
            dimmed=false
        fi
    fi

    # Warn about low battery
    if [ "$bat" -le "$WARN_BATTERY" ]; then
        notify-send "Battery low" "$bat% remaining" -u critical
    fi

    sleep 5
done
