#!/bin/sh

calcurse_term="foot"
notes_term="kitty"

if hyprctl clients | grep -q "class: dashboard-calcurse" || \
   hyprctl clients | grep -q "class: dashboard-notes"; then

    hyprctl dispatch closewindow "class:^(dashboard-calcurse)$"
    hyprctl dispatch closewindow "class:^(dashboard-notes)$"

else

    uwsm app -- "$calcurse_term" --app-id dashboard-calcurse calcurse &
    uwsm app -- "$notes_term" --app-id dashboard-notes fzf-notes &

fi
