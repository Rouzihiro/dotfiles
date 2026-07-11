#!/bin/sh

echo "Stopping dashboard..."

pkill -f "$HOME/dashboard/scripts/update.sh"
pkill -f "$HOME/dashboard/scripts/launcher.py"
pkill -f "python3 -m http.server 8080"

echo "Dashboard stopped."
