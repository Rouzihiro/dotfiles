#!/usr/bin/bash

while true :; do

  Vol="^c#83a598^ ^c#ebdbb2^$(pamixer --get-volume-human)"
  Bat="^c#b8bb26^ ^c#ebdbb2^$(cat /sys/class/power_supply/macsmc-battery/capacity)%"
  Day="^c#fabd2f^ ^c#ebdbb2^$(date '+%a,%Y-%m-%d')"
  Time="^c#d3869b^ ^c#ebdbb2^$(date '+%I:%M %p')"
  Music=" ^c#cba6f7^ ^c#ebdbb2^$(playerctl metadata --format "{{ artist }} - {{ title }}" | awk '{print substr($0, 1, 32)}')"
  Bklit="^c#fe8019^󰃟 ^c#ebdbb2^$(brightnessctl i | awk '/Current brightness/ {print $4}' | sed 's/[()]//g')"
  xsetroot -name "$Music | $Vol | $Bklit | $Bat | $Day | $Time"

  sleep 1

done
