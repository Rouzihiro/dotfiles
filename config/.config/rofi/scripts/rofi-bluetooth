#!/usr/bin/env bash

# Constants
goback=" Back"

# Checks if bluetooth controller is powered on
power_on() {
    bluetoothctl show | grep -q "Powered: yes"
}

# Toggles power state
toggle_power() {
    if power_on; then
        bluetoothctl power off
        notify-send -a "System" -i "preferences-desktop" "Bluetooth" "Powered off"
    else
        if rfkill list bluetooth | grep -q 'blocked: yes'; then
            rfkill unblock bluetooth && sleep 3
        fi
        bluetoothctl power on
        notify-send -a "System" -i "preferences-desktop" "Bluetooth" "Powered on"
    fi
    show_menu
}

# Checks if controller is scanning for new devices
scan_on() {
    bluetoothctl show | grep -q "Discovering: yes"
}

# Toggles scanning state
toggle_scan() {
    if scan_on; then
        kill $(pgrep -f "bluetoothctl --timeout 5 scan on") 2>/dev/null
        bluetoothctl scan off
    else
        bluetoothctl --timeout 5 scan on &
    fi
    show_menu
}

# Checks if controller is able to pair to devices
pairable_on() {
    bluetoothctl show | grep -q "Pairable: yes"
}

# Toggles pairable state
toggle_pairable() {
    if pairable_on; then
        bluetoothctl pairable off
    else
        bluetoothctl pairable on
    fi
    show_menu
}

# Checks if controller is discoverable by other devices
discoverable_on() {
    bluetoothctl show | grep -q "Discoverable: yes"
}

# Toggles discoverable state
toggle_discoverable() {
    if discoverable_on; then
        bluetoothctl discoverable off
    else
        bluetoothctl discoverable on
    fi
    show_menu
}

# Checks if a device is connected
device_connected() {
    bluetoothctl info "$1" | grep -q "Connected: yes"
}

# Toggles device connection
toggle_connection() {
    device_name=$(bluetoothctl info "$1" | grep "Alias" | cut -d ' ' -f 2-)
    if device_connected "$1"; then
        bluetoothctl disconnect "$1"
        notify-send -a "System" -i "preferences-desktop" "Bluetooth" "Disconnected from $device_name"
    else
        bluetoothctl connect "$1"
        notify-send -a "System" -i "preferences-desktop" "Bluetooth" "Connected to $device_name"
    fi
    device_menu "$device"
}

# Checks if a device is paired
device_paired() {
    bluetoothctl info "$1" | grep -q "Paired: yes"
}

# Toggles device paired state
toggle_paired() {
    device_name=$(bluetoothctl info "$1" | grep "Alias" | cut -d ' ' -f 2-)
    if device_paired "$1"; then
        bluetoothctl remove "$1"
        notify-send -a "System" -i "preferences-desktop" "Bluetooth" "Removed $device_name"
        show_menu
    else
        bluetoothctl pair "$1"
        notify-send -a "System" -i "preferences-desktop" "Bluetooth" "Paired with $device_name"
        device_menu "$device"
    fi
}

# Checks if a device is trusted
device_trusted() {
    bluetoothctl info "$1" | grep -q "Trusted: yes"
}

# Toggles device trust
toggle_trust() {
    device_name=$(bluetoothctl info "$1" | grep "Alias" | cut -d ' ' -f 2-)
    if device_trusted "$1"; then
        bluetoothctl untrust "$1"
        notify-send -a "System" -i "preferences-desktop" "Bluetooth" "Untrusted $device_name"
    else
        bluetoothctl trust "$1"
        notify-send -a "System" -i "preferences-desktop" "Bluetooth" "Trusted $device_name"
    fi
    device_menu "$device"
}

# Prints bluetooth status for waybar
print_status() {
    if power_on; then
        printf ''

        paired_devices_cmd="devices Paired"
        if (( $(bluetoothctl version | cut -d ' ' -f 2 | cut -d '.' -f 1) < 5 )); then
            paired_devices_cmd="paired-devices"
        fi

        mapfile -t paired_devices < <(bluetoothctl $paired_devices_cmd | grep Device | cut -d ' ' -f 2)
        counter=0

        for device in "${paired_devices[@]}"; do
            if device_connected "$device"; then
                device_alias=$(bluetoothctl info "$device" | grep "Alias" | cut -d ' ' -f 2-)

                if [ $counter -gt 0 ]; then
                    printf ", %s" "$device_alias"
                else
                    printf " %s" "$device_alias"
                fi

                ((counter++))
            fi
        done
        printf "\n"
    else
        echo ""
    fi
}

# Device submenu with icons
device_menu() {
    device=$1
    device_name=$(echo "$device" | cut -d ' ' -f 3-)
    mac=$(echo "$device" | cut -d ' ' -f 2)

    # Build options with icons
    if device_connected "$mac"; then
        connected="󰂲 Disconnect"
    else
        connected="󰂱 Connect"
    fi

    if device_paired "$mac"; then
        paired=" Unpair"
    else
        paired=" Pair"
    fi

    if device_trusted "$mac"; then
        trusted=" Untrust"
    else
        trusted=" Trust"
    fi

    options="$connected\n$paired\n$trusted\n$goback"

    chosen="$(echo -e "$options" | rofi -dmenu -i -p "$device_name")"

    case "$chosen" in
        "$connected")
            toggle_connection "$mac"
            ;;
        "$paired")
            toggle_paired "$mac"
            ;;
        "$trusted")
            toggle_trust "$mac"
            ;;
        "$goback")
            show_menu
            ;;
    esac
}

# Main menu
show_menu() {
    if power_on; then
        power="⏻ Power: ON"

        # Get all devices
        paired_devices_cmd="devices Paired"
        if (( $(bluetoothctl version | cut -d ' ' -f 2 | cut -d '.' -f 1) < 5 )); then
            paired_devices_cmd="paired-devices"
        fi

        mapfile -t all_devices < <(bluetoothctl devices | grep Device)

        # Separate connected and other devices
        connected_list=""
        other_list=""

        for device_line in "${all_devices[@]}"; do
            mac=$(echo "$device_line" | cut -d ' ' -f 2)
            name=$(echo "$device_line" | cut -d ' ' -f 3-)

            if device_connected "$mac"; then
                connected_list+=" Connected: $name\n"
            else
                other_list+="$name\n"
            fi
        done

        # Build menu: connected devices first, then others, then controls
        if [ -n "$connected_list" ]; then
            devices=$(echo -e "${connected_list}${other_list}" | sed '/^$/d')
        else
            devices=$(echo -e "$other_list" | sed '/^$/d')
        fi

        # Controller status
        if scan_on; then
            scan=" Scan: ON"
        else
            scan=" Scan: OFF"
        fi

        if pairable_on; then
            pairable="󱘖 Pairable: ON"
        else
            pairable="󱘖 Pairable: OFF"
        fi

        if discoverable_on; then
            discoverable=" Discoverable: ON"
        else
            discoverable=" Discoverable: OFF"
        fi

        options="$devices\n$power\n$scan\n$pairable\n$discoverable"
    else
        power="⏻ Power: OFF"
        options="$power"
    fi

    chosen="$(echo -e "$options" | rofi -dmenu -i -p "Bluetooth")"

    case "$chosen" in
        "$power")
            toggle_power
            ;;
        "$scan")
            toggle_scan
            ;;
        "$discoverable")
            toggle_discoverable
            ;;
        "$pairable")
            toggle_pairable
            ;;
        "")
            ;;
        *)
            # Strip " Connected: " prefix if present
            device_name="${chosen#*Connected: }"
            device=$(bluetoothctl devices | grep "$device_name")
            if [[ $device ]]; then
                device_menu "$device"
            fi
            ;;
    esac
}

case "$1" in
    --status)
        print_status
        ;;
    *)
        show_menu
        ;;
esac
