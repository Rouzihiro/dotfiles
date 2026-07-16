#!/usr/bin/env bash

# Dashboard launcher for Qtile Wayland

set -e

DASHBOARD_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "$DASHBOARD_DIR" || exit 1


# --------------------------------------------------
# Prepare directories
# --------------------------------------------------

mkdir -p data
mkdir -p "$HOME/Projects"


# Create convenient symlink
if [ ! -e "$HOME/Projects/dashboard" ]; then
    ln -s "$DASHBOARD_DIR" "$HOME/Projects/dashboard"
fi


# --------------------------------------------------
# Build dashboard
# --------------------------------------------------

if [ -x "./scripts/build-dashboard.sh" ]; then
    ./scripts/build-dashboard.sh
fi


# Sync theme
if [ -x "./scripts/update-theme.sh" ]; then
    ./scripts/update-theme.sh
fi


# --------------------------------------------------
# Start live data updater
# --------------------------------------------------

if ! pgrep -f "[s]cripts/update.sh" >/dev/null; then

    if [ -x "./scripts/update.sh" ]; then
        ./scripts/update.sh >/dev/null 2>&1 &
    fi

fi


# --------------------------------------------------
# Start launcher bridge
# --------------------------------------------------

if ! pgrep -f "[s]cripts/launcher.py" >/dev/null; then

    python3 \
        "$DASHBOARD_DIR/scripts/launcher.py" \
        >/dev/null 2>&1 &

fi


# --------------------------------------------------
# Launch GTK dashboard window
# --------------------------------------------------

if ! pgrep -f "[d]ashboard.py" >/dev/null; then

    sleep 1

    python3 \
        "$DASHBOARD_DIR/dashboard.py" \
        >/tmp/dashboard.log 2>&1 &

fi


exit 0
