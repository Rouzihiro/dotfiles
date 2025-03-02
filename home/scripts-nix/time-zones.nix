{pkgs, ...}:
pkgs.writeShellScriptBin "time-zones" ''

  yad --width=800 --height=650 \
    --center \
    --fixed \
    --title="Current Times in Major Cities" \
    --no-buttons \
    --list \
    --column=City: \
    --column=Time: \
    --timeout=90 \
    --timeout-indicator=right \
    $(for city in "Hamburg" "Paris" "London" "Phoenix" "Tokyo"; do \
        echo -n "$city: $(TZ=''${city} date '+%H:%M:%S')\n"; \
      done)

''
