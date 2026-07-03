#!/bin/sh

calcurse_term="foot"
notes_term="kitty"

if swaymsg -t get_tree | grep -q '"app_id": "dashboard-calcurse"' || \
   swaymsg -t get_tree | grep -q '"app_id": "dashboard-notes"'; then

    swaymsg '[app_id="^dashboard-calcurse$"] kill'
    swaymsg '[app_id="^dashboard-notes$"] kill'

else

    "$calcurse_term" --app-id dashboard-calcurse calcurse &
    "$notes_term" --app-id dashboard-notes fzf-notes &

fi