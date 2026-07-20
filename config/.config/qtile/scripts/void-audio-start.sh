#!/bin/sh

# Give Qtile/Wayland time to initialize
sleep 3

export XDG_RUNTIME_DIR=/run/user/$(id -u)
export DBUS_SESSION_BUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/bus"

# Stop existing audio processes
pkill pipewire 2>/dev/null
pkill pipewire-pulse 2>/dev/null
pkill wireplumber 2>/dev/null

# Small delay so sockets are released
sleep 1

# Start PipeWire stack
pipewire &
pipewire-pulse &
wireplumber &
