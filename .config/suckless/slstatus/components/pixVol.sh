#!/bin/bash

volume=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '\d+%' | head -n 1 | tr -d '%')
muted=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')

if [ "$muted" = "yes" ]; then
  echo "Muted"
else
  echo "${volume}"
fi
