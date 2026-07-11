#!/bin/sh

# Directory containing this script
DASHBOARD_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

cd "$DASHBOARD_DIR" || exit 1


# Ensure required directories exist
mkdir -p data
mkdir -p "$HOME/Projects"


# Create convenient symlink in ~/Projects
if [ ! -L "$HOME/Projects/dashboard" ] && [ ! -e "$HOME/Projects/dashboard" ]; then
    ln -s "$DASHBOARD_DIR" "$HOME/Projects/dashboard"
fi


# Build dashboard cards
./scripts/build-dashboard.sh


# Sync dashboard colors
./scripts/update-theme.sh


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


# Open dashboard
xdg-open http://localhost:8080 >/dev/null 2>&1
