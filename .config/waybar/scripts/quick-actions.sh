#!/usr/bin/env bash

menu=(
    " Keybinds"
    " Keybinds 2"
    " Calculator"
    "󰹑 Screenshot"
    "󰅇 Clipboard"
    " Code"
    "󰒓 Theme"
    "󰍛 Hardware"
    " VPN"
    " Packages"
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
        "󰒓 Theme")
            # Theme submenu
            theme_menu=(
                " Wallpaper"
                "󰞅 Emojis"
                " Icons"
                "󰝰 GTK-Theme-Installer"
            )
            
            theme_selected=$(printf '%s\n' "${theme_menu[@]}" | rofi -dmenu -i -p "Theme" -theme ~/.config/rofi/quick-actions.rasi)
            
            case "$theme_selected" in
                " Wallpaper")
                    "rofi-wall"
                    ;;
                "󰞅 Emojis")
                    rofi -show emoji -theme ~/.config/rofi/config.rasi
                    ;;
                " Icons")
                    ~/.config/waybar/scripts/icon-picker.sh
                    ;;
                "󰝰 GTK-Theme-Installer")
										"z-theme-set-gtk"    
                    ;;
            esac
            ;;
        "󰍛 Hardware")
            # Hardware submenu
            hardware_menu=(
                "󰁹 Power"
                " Bluetooth"
                "󰖩 WiFi"
                "󰂰 Power Profile"
                "󰕾 Sound"
            )
            
            hardware_selected=$(printf '%s\n' "${hardware_menu[@]}" | rofi -dmenu -i -p "Hardware" -theme ~/.config/rofi/quick-actions.rasi)
            
            case "$hardware_selected" in
                "󰁹 Power")
                    "rofi-power"
                    ;;
                " Bluetooth")
                    "rofi-bluetooth"
                    ;;
                "󰖩 WiFi")
                    "rofi-wifi"
                    ;;
                "󰂰 Power Profile")
                    "rofi-power-profile"
                    ;;
                "󰕾 Sound")
                    ~/.config/waybar/scripts/rofi-audio.sh
                    ;;
            esac
            ;;
        " VPN")
            ~/.config/waybar/scripts/tailscale.sh
            ;;
        " Packages")
            ~/.config/waybar/scripts/installer-wrapper.sh
            ;;
        " Keybinds")
            ~/.config/waybar/scripts/cheatsheet.sh
            ;;
        " Keybinds 2")
            "$HOME/.local/bin/zorro/z-menu-keybindings-sway-soft"
            ;;
        " Calculator")
            rofi -show calc -modi calc -no-show-match -no-sort
            ;;
    esac
fi
