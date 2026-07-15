#!/bin/bash

## Volume control script
##
## Usage:
##   up     : Increase volume
##   down   : Decrease volume
##   mute   : Toggle speaker mute
##   mic    : Toggle microphone mute
##
## Requirements:
##   - wireplumber (wpctl)
##   - mako / notification daemon

msgTag="volume"
TIME=800

# Nerd Font volume symbols
get_volume_icon() {
    local vol=$1

    if [ "$vol" -eq 0 ]; then
        echo "󰖁"
    elif [ "$vol" -ge 65 ]; then
        echo "󰕾"
    elif [ "$vol" -ge 30 ]; then
        echo "󰖀"
    else
        echo "󰕿"
    fi
}

notify_volume() {
    local volume=$1

    notify-send -t "$TIME" \
        -a "Volume" \
        -h string:x-canonical-private-synchronous:$msgTag \
        "$(get_volume_icon "$volume")  Volume: ${volume}%"
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

        if [[ "$mute" == "yes" ]]; then
            notify-send -t "$TIME" \
                -a "Volume" \
                -h string:x-canonical-private-synchronous:$msgTag \
                "󰖁  Muted"
        else
            volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2*100)}')
            notify-send -t "$TIME" \
                -a "Volume" \
                -h string:x-canonical-private-synchronous:$msgTag \
                "$(get_volume_icon "$volume")  Unmuted"
        fi

        exit 0
        ;;

    mic)
        wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle

        mic_mute=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -q MUTED && echo "yes" || echo "no")

        if [[ "$mic_mute" == "yes" ]]; then
            notify-send -t "$TIME" \
                -a "Mic" \
                -h string:x-canonical-private-synchronous:$msgTag \
                "󰍭  Mic muted"
        else
            notify-send -t "$TIME" \
                -a "Mic" \
                -h string:x-canonical-private-synchronous:$msgTag \
                "󰍬  Mic unmuted"
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
    notify_volume "$volume"
fi
