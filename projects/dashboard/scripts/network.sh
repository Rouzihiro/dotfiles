#!/bin/sh

DATA="$HOME/dashboard/data/network.json"


# Find active interface
IFACE=$(ip route | awk '/default/ {print $5; exit}')


# WiFi information
if command -v nmcli >/dev/null 2>&1; then

    WIFI=$(nmcli -t -f active,ssid,signal dev wifi | grep '^yes')

    SSID=$(echo "$WIFI" | cut -d: -f2)
    SIGNAL=$(echo "$WIFI" | cut -d: -f3)

else

    SSID="unknown"
    SIGNAL="unknown"

fi


# Traffic calculation

if [ -n "$IFACE" ]; then

    RX1=$(cat /sys/class/net/$IFACE/statistics/rx_bytes)
    TX1=$(cat /sys/class/net/$IFACE/statistics/tx_bytes)

    sleep 1

    RX2=$(cat /sys/class/net/$IFACE/statistics/rx_bytes)
    TX2=$(cat /sys/class/net/$IFACE/statistics/tx_bytes)


    DOWNLOAD=$(( (RX2-RX1) / 1024 ))
    UPLOAD=$(( (TX2-TX1) / 1024 ))

else

    DOWNLOAD=0
    UPLOAD=0

fi



cat > "$DATA" <<EOF
{
    "ssid": "$SSID",
    "signal": "${SIGNAL}%",
    "download": "${DOWNLOAD} KB/s",
    "upload": "${UPLOAD} KB/s"
}
EOF
