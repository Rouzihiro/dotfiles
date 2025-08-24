#!/bin/bash

# Check if the device is connected to a WiFi network
connected_wifi=$(nmcli -t -f ACTIVE,SSID dev wifi | grep '^yes')

if [ -z "$connected_wifi" ]; then
    # No WiFi connection
    echo "no"
else
    # A WiFi network is connected
    nmcli -t -f ACTIVE,SSID dev wifi | grep '^yes' | cut -d':' -f2
fi

