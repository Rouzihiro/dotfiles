{pkgs}:
pkgs.writeShellScriptBin "calendar-events" ''
  yad --width=800 --height=650 \
    --center \
    --fixed \
    --title="Upcoming Calendar Events" \
    --no-buttons \
    --list \
    --column=Event: \
    --column=Date: \
    --timeout=90 \
    --timeout-indicator=right \
    $(cal -A 2 | awk '{print $1,$2,$3, $6}')
''
