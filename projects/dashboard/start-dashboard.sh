#!/bin/sh

cd "$HOME/dashboard" || exit 1


# Start live data updater
if ! pgrep -f "scripts/update.sh" >/dev/null; then
    ./scripts/update.sh &
fi


# Start launcher bridge
if ! pgrep -f "scripts/launcher.py" >/dev/null; then
    python3 scripts/launcher.py &
fi


# Start dashboard web server
if ! pgrep -f "http.server 8080" >/dev/null; then
    python3 -m http.server 8080 &
fi


sleep 1


xdg-open http://localhost:8080 >/dev/null 2>&1
