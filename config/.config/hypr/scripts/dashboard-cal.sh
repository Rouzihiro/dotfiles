#!/bin/sh

calcurse_term="foot"
termcal_term="kitty"

if hyprctl clients | grep -q "class: dashboard-calcurse" || \
   hyprctl clients | grep -q "class: dashboard-notes"; then

    hyprctl dispatch closewindow "class:^(dashboard-calcurse)$"
    hyprctl dispatch closewindow "class:^(dashboard-termcal)$"

else

    uwsm app -- "$calcurse_term" --app-id dashboard-calcurse calcurse &
    uwsm app -- "$termcal_term" --app-id dashboard-termcal termcal &

fi
