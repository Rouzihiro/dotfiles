#!/bin/sh

calcurse_term="foot"
termcal_term="kitty"

if swaymsg -t get_tree | grep -q '"app_id": "dashboard-calcurse"' || \
   swaymsg -t get_tree | grep -q '"app_id": "dashboard-termcal"'; then

    swaymsg '[app_id="^dashboard-calcurse$"] kill'
    swaymsg '[app_id="^dashboard-termcal$"] kill'

else

    "$calcurse_term" --app-id dashboard-calcurse calcurse &
    "$termcal_term" --app-id dashboard-termcal termcal &

fi