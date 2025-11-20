#!/usr/bin/env bash

# Read pre-parsed icon list (much faster than parsing CSV each time)
icon_list=$(cat ~/.config/waybar/nerd-icons-parsed.txt)

# Show rofi menu with icon list
selected_icon=$(echo "$icon_list" | rofi -dmenu -i -p "Icon Picker" -theme ~/.config/rofi/config.rasi)

# Copy selected icon to clipboard
if [ -n "$selected_icon" ]; then
    icon=$(echo "$selected_icon" | awk '{print $1}')
    echo -n "$icon" | wl-copy
    notify-send -a "System" "Icon Picker" "Copied: $icon" -i preferences-desktop
fi
