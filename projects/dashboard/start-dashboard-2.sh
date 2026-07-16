#!/bin/sh

# Dashboard launcher for Qtile Wayland

DASHBOARD_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

cd "$DASHBOARD_DIR" || exit 1


# Ensure required directories exist
mkdir -p data
mkdir -p "$HOME/Projects"


# Create convenient symlink
if [ ! -L "$HOME/Projects/dashboard" ] && [ ! -e "$HOME/Projects/dashboard" ]; then
    ln -s "$DASHBOARD_DIR" "$HOME/Projects/dashboard"
fi


# Build dashboard cards
./scripts/build-dashboard.sh


# Sync dashboard theme
./scripts/update-theme.sh


# Start live data updater
if ! pgrep -f "scripts/update.sh" >/dev/null; then
    ./scripts/update.sh >/dev/null 2>&1 &
fi


# Start launcher bridge
if ! pgrep -f "scripts/launcher.py" >/dev/null; then
    python3 scripts/launcher.py >/dev/null 2>&1 &
fi


# Launch native Qtile dashboard window
if ! pgrep -f "dashboard.py" >/dev/null; then
    python3 dashboard.py >/dev/null 2>&1 &
fi
