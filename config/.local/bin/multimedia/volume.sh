#!/bin/bash

## This script allows adjusting volume and microphone settings using:
##   - up   : Increase volume
##   - down : Decrease volume
##   - mute : Toggle mute for speakers
##   - mic  : Toggle mute for the microphone

## Features:
## - Displays appropriate volume icons based on current levels.
## - Sends notifications with `notify-send` (Mako).

## Requirements:
## - `wireplumber`: Uses `wpctl` for audio control.
## - `mako`: Required for notifications.

msgTag="volume"
icon_path="$HOME/.local/share/icons/dunst"
TIME=2000 

# Function to get the appropriate volume icon based on level
get_volume_icon() {
    local vol=$1
    if [ $vol -eq 0 ]; then
        echo "$icon_path/mute.png"
    elif [ $vol -ge 65 ]; then
        echo "$icon_path/volume-high.png"
    elif [ $vol -ge 30 ]; then
        echo "$icon_path/volume-mid.png"
    else
        echo "$icon_path/volume.png"
    fi
}

case "$1" in
    up)
        wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 2%+
        ;;
    down)
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-
        ;;
    mute)
        wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
        mute=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q MUTED && echo "yes" || echo "no")
        volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2*100)}')
        if [[ "$mute" == "yes" ]]; then
            notify-send -t $TIME \
                     -a "Volume" -i "$icon_path/mute.png" \
                     -h string:x-canonical-private-synchronous:$msgTag "Muted"
        else
            notify-send -t $TIME \
                     -a "Volume" -i "$(get_volume_icon $volume)" \
                     -h string:x-canonical-private-synchronous:$msgTag "Unmuted"
        fi
        exit 0
        ;;
    mic)
        wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
        mic_mute=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -q MUTED && echo "yes" || echo "no")
        if [[ "$mic_mute" == "yes" ]]; then
            notify-send -t $TIME \
                     -a "Mic" \
                     -h string:x-canonical-private-synchronous:$msgTag "Muted"
        else
            notify-send -t $TIME \
                     -a "Mic" \
                     -h string:x-canonical-private-synchronous:$msgTag "Unmuted"
        fi
        exit 0
        ;;
    *)
        echo "Usage: $0 [up/down/mute/mic]"
        exit 1
        ;;
esac

volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2*100)}')
mute=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q MUTED && echo "yes" || echo "no")
if [[ "$mute" != "yes" ]]; then
    notify-send -t $TIME \
             -a "Volume" -i "$(get_volume_icon $volume)" \
             -h string:x-canonical-private-synchronous:$msgTag \
             "Volume: $volume%"
fi
