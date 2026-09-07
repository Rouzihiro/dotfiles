#!/usr/bin/env bash

# Kill existing sketchybar instances
killall sketchybar

# Wait a moment for processes to terminate
sleep 1

# Start sketchybar with new configuration
sketchybar --config "$HOME/.config/sketchybar/sketchybarrc"

echo "SketchyBar restarted with new aesthetic configuration!"
echo "✨ Features included:"
echo "  • Modern Catppuccin color scheme"
echo "  • Beautiful aerospace workspace tiles"
echo "  • Active workspace highlighting"
echo "  • Enhanced battery, volume, and weather widgets"
echo "  • Smooth animations and transitions"
echo "  • Clean, minimal design" 