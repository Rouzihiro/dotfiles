{ pkgs }:
pkgs.writeShellScriptBin "weather-info" ''
yad --width=800 --height=650 \
  --center \
  --fixed \
  --title="Current Weather" \
  --no-buttons \
  --list \
  --column=Weather: \
  --timeout=90 \
  --timeout-indicator=right \
  "$(curl -s "wttr.in/Hamburg?format=%l:+%C+%t+%w+%h+%m&lang=de")" \
  "$(curl -s "wttr.in/Hannover?format=%l:+%C+%t+%w+%h+%m&lang=de")" \
  "$(curl -s "wttr.in/Heidelberg?format=%l:+%C+%t+%w+%h+%m&lang=de")" \
  "$(curl -s "wttr.in/Muenster?format=%l:+%C+%t+%w+%h+%m&lang=de")" \
  "$(curl -s "wttr.in/London?format=%l:+%C+%t+%w+%h+%m&lang=de")" \
  "$(curl -s "wttr.in/Phoenix?format=%l:+%C+%t+%w+%h+%m&lang=de")" \
  "$(curl -s "wttr.in/Mallorca?format=%l:+%C+%t+%w+%h+%m&lang=de")" \
  "$(curl -s "wttr.in/Malaga?format=%l:+%C+%t+%w+%h+%m&lang=de")" \
  "$(curl -s "wttr.in/Mallorca?format=%l:+%C+%t+%w+%h+%m&lang=de")" \
  "$(curl -s "wttr.in/Barcelona?format=%l:+%C+%t+%w+%h+%m&lang=de")" \
  "$(curl -s "wttr.in/Sitges?format=%l:+%C+%t+%w+%h+%m&lang=de")" \
  "$(curl -s "wttr.in/Split?format=%l:+%C+%t+%w+%h+%m&lang=de")" \
  "$(curl -s "wttr.in/Belek?format=%l:+%C+%t+%w+%h+%m&lang=de")" \
  "$(curl -s "wttr.in/Bolzano?format=%l:+%C+%t+%w+%h+%m&lang=de")" \
  "$(curl -s "wttr.in/Compatsch?format=%l:+%C+%t+%w+%h+%m&lang=de")" \
  "$(curl -s "wttr.in/Oslo?format=%l:+%C+%t+%w+%h+%m&lang=de")" \
  "$(curl -s "wttr.in/Tokyo?format=%l:+%C+%t+%w+%h+%m&lang=de")"
''
