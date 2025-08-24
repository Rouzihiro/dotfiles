#!/usr/bin/bash

while true; do
  # Kanagawa colors
  FG="#dcd7ba"   # default foreground
  VOL="#7e9cd8"  # blue
  BAT="#98bb6c"  # green
  DAY="#e6c384"  # yellow
  TIME="#957fb8" # purple
  MUS="#c8a6ff"  # softer violet (matches style)
  BKLIT="#ffa066" # orange

  Vol="^c${VOL}^ ^c${FG}^$(pamixer --get-volume-human)"
  Bat="^c${BAT}^ ^c${FG}^$(cat /sys/class/power_supply/macsmc-battery/capacity)%"
  Day="^c${DAY}^ ^c${FG}^$(date '+%a,%Y-%m-%d')"
  Time="^c${TIME}^ ^c${FG}^$(date '+%I:%M %p')"
  Music=" ^c${MUS}^ ^c${FG}^$(playerctl metadata --format "{{ artist }} - {{ title }}" | awk '{print substr($0, 1, 32)}')"
  Bklit="^c${BKLIT}^󰃟 ^c${FG}^$(brightnessctl i | awk '/Current brightness/ {print $4}' | sed 's/[()]//g')"

  xsetroot -name "$Music | $Vol | $Bklit | $Day | $Time | $Bat"
  sleep 1
done

