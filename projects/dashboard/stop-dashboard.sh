#!/bin/sh

echo "Stopping dashboard..."

pkill -f "scripts/update.sh"
pkill -f "scripts/launcher.py"
pkill -f "http.server 8080"

echo "Dashboard stopped."
