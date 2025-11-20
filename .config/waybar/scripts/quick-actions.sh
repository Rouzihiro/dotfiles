#!/usr/bin/env bash

menu=(
    " Keybinds"
 		" Keybinds 2"
 		" Keybinds 3"
    " Calculator"
    "󰹑 Screenshot"
    "󰅇 Clipboard"
    " Code"
    "󰞅 Emojis"
    " Icons"
    " Picker"
    " VPN"
    " Packages"
    " Bluetooth"
    "󰁹 Power"
)

# Show rofi menu
selected=$(printf '%s\n' "${menu[@]}" | rofi -dmenu -i -p "Quick Actions" -theme ~/.config/rofi/quick-actions.rasi)

# Handle selection
if [ -n "$selected" ]; then
    case "$selected" in
        "󰹑 Screenshot")
            ~/.config/waybar/scripts/take-screenshot.sh
            ;;
        "󰅇 Clipboard")
            clipse-gui
            ;;
        " Code")
            ~/.config/waybar/scripts/code-launcher.sh
            ;;
        "󰞅 Emojis")
            rofi -show emoji -theme ~/.config/rofi/config.rasi
            ;;
        " Icons")
            ~/.config/waybar/scripts/icon-picker.sh
            ;;
        " Picker")
            ~/.config/waybar/scripts/color-picker.sh
            ;;
        " VPN")
            ~/.config/waybar/scripts/tailscale.sh
            ;;
        " Packages")
            ~/.config/waybar/scripts/installer-wrapper.sh
            ;;
        " Bluetooth")
            ~/.config/waybar/scripts/rofi-bluetooth.sh
            ;;
        "󰁹 Power")
            ~/.config/waybar/scripts/power-profile.sh
            ;;
        " Keybinds")
            ~/.config/waybar/scripts/cheatsheet.sh
            ;;
 				" Keybinds 2")
						"$HOME/.local/bin/zorro/z-menu-keybindings-sway-soft"
	    			;;
 				" Keybinds 3")
						"$HOME/.local/bin/zorro/z-menu-keybindings-sway-hard"
						;;
        " Calculator")
            rofi -show calc -modi calc -no-show-match -no-sort
            ;;
    esac
fi
