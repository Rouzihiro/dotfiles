#!/bin/sh

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
DASHBOARD_DIR="$(dirname "$SCRIPT_DIR")"
DATA_DIR="$DASHBOARD_DIR/data"

mkdir -p "$DATA_DIR"

DATA="$DATA_DIR/hardware.json"


# Battery

if [ -d /sys/class/power_supply/BAT0 ]; then

    BATTERY=$(cat /sys/class/power_supply/BAT0/capacity)
    STATUS=$(cat /sys/class/power_supply/BAT0/status)

else

    BATTERY="N/A"
    STATUS="N/A"

fi


# CPU temperature

TEMP="N/A"

for zone in /sys/class/thermal/thermal_zone*/temp; do

    if [ -f "$zone" ]; then

        VALUE=$(cat "$zone")

        if [ "$VALUE" -gt 0 ]; then
            TEMP="$((VALUE / 1000))°C"
            break
        fi

    fi

done


cat > "$DATA" <<EOF
{
    "battery": "$BATTERY%",
    "battery_status": "$STATUS",
    "temperature": "$TEMP"
}
EOF
