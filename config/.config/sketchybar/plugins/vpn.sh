#!/usr/bin/env bash

CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}"
source "$CONFIG_DIR/colors.sh"

VPN_CONNECTED=false
VPN_NAME=""

MULLVAD_PROCESSES=$(ps aux | grep -i mullvad | grep -v grep)
if [[ -n "$MULLVAD_PROCESSES" ]]; then
    MULLVAD_STATUS=$(mullvad status 2>/dev/null | grep -i "connected")
    if [[ -n "$MULLVAD_STATUS" ]]; then
        VPN_CONNECTED=true
        VPN_NAME="Mullvad"
    fi
fi

if [[ "$VPN_CONNECTED" == false ]]; then
    WG_INTERFACES=$(ifconfig | grep "utun" | awk '{print $1}' | sed 's/://')
    for interface in $WG_INTERFACES; do
        if [[ -n "$interface" ]]; then
            VPN_IP=$(ifconfig "$interface" 2>/dev/null | grep "inet " | awk '{print $2}' | head -1)
            if [[ -n "$VPN_IP" && "$VPN_IP" != "127.0.0.1" ]]; then
                ROUTE_CHECK=$(route get default 2>/dev/null | grep interface | awk '{print $2}')
                if [[ "$ROUTE_CHECK" == "$interface" ]]; then
                    VPN_CONNECTED=true
                    VPN_NAME="WireGuard"
                    break
                fi
            fi
        fi
    done
fi

if [[ "$VPN_CONNECTED" == false ]]; then
    VPN_SERVICES=$(scutil --nc list | grep -E "(Connected|Mullvad|WireGuard)" | grep -v "Wi-Fi")
    if [[ -n "$VPN_SERVICES" ]]; then
        VPN_CONNECTED=true
        VPN_NAME="VPN"
    fi
fi

if [[ "$VPN_CONNECTED" == true ]]; then
    sketchybar --set "$NAME" \
        icon="󰌾" \
        icon.color=$SUCCESS \
        label="$VPN_NAME" \
        label.color=$FG \
        label.drawing=on
else
    sketchybar --set "$NAME" \
        icon="󰌾" \
        icon.color=$FG_FAINT \
        label="Disconnected" \
        label.color=$FG_DIM \
        label.drawing=on
fi
