#!/usr/bin/bash

while true; do
  Vol=" $(pamixer --get-volume-human)"
  Bat=" $(cat /sys/class/power_supply/macsmc-battery/capacity)%"
  Day=" $(date '+%a, %Y-%m-%d')"
  Time=" $(date '+%I:%M %p')"
  Music=" $(playerctl metadata --format '{{ artist }} - {{ title }}' | cut -c1-32)"
  Bklit="󰃟 $(brightnessctl i | awk '/Current brightness/ {print $4}' | tr -d '()')"

  xsetroot -name "$Music | $Vol | $Bklit | $Day | $Time | $Bat"
  sleep 1
done

