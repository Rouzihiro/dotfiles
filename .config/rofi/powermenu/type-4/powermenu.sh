#!/usr/bin/env bash

# Minimal Rofi Power Menu for dwm with theme (symbols only)

dir="$HOME/.config/rofi/powermenu/type-4"
theme='style-5'

uptime="$(uptime -p | sed -e 's/up //g')"

# Symbols
shutdown='⏻'
reboot='🔄'
lock='🔒'
logout='🚪'
yes='✔'
no='✘'

# Rofi menu
rofi_cmd() {
    rofi -dmenu -p "Goodbye ${USER}" -mesg "Uptime: $uptime" -theme "${dir}/${theme}.rasi"
}

# Confirmation menu
confirm_cmd() {
    rofi -dmenu -p 'Confirmation' -mesg 'Are you sure?' -theme "${dir}/shared/confirm.rasi"
}

confirm_exit() {
    echo -e "$yes\n$no" | confirm_cmd
}

run_cmd() {
    selected="$(confirm_exit)"
    if [[ "$selected" == "$yes" ]]; then
        case $1 in
            --poweroff) poweroff ;;
            --reboot) reboot ;;
            --logout) pkill dwm ;;
        esac
    fi
}

# Show menu (symbols only)
chosen="$(echo -e "$lock\n$logout\n$reboot\n$shutdown" | rofi_cmd)"

# Execute selection
case "$chosen" in
    "$shutdown") run_cmd --poweroff ;;
    "$reboot") run_cmd --reboot ;;
    "$lock") i3lock ;;
    "$logout") run_cmd --logout ;;
esac
