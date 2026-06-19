#!/bin/bash

## This script adjusts the screen brightness using `brightnessctl`
## and displays a notification with the updated brightness level.

## Requirements:
## - `brightnessctl`: Controls screen brightness.
## - `mako`: Sends notifications.

## Usage:
## - Run with `up` to increase brightness.
## - Run with `down` to decrease brightness.

msgTag="brightness"

if [[ $# -ne 1 ]] || [[ "$1" != "up" && "$1" != "down" ]]; then
    echo "Usage: $0 [up/down]"
    exit 1
fi

if [[ "$1" == "up" ]]; then
    brightnessctl -e4 set +5%
else
    brightnessctl -e4 set 5%-
fi

current=$(brightnessctl get)
max=$(brightnessctl max)
percentage=$((current * 100 / max))

notify-send -t 3000 \
         -a "Brightness" -i "$HOME/.local/share/icons/dunst/brightness.png" \
         -h string:x-canonical-private-synchronous:$msgTag \
         "Brightness: ${percentage}%"
