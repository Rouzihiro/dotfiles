#!/bin/sh

set -e

# Function to enable a system service (sudo required)
enable_system_service() {
    SERVICE="$1"
    if sudo systemctl is-enabled --quiet "$SERVICE"; then
        echo "✔️ $SERVICE is already enabled (system)"
    else
        echo "➕ Enabling $SERVICE (system)..."
        sudo systemctl enable "$SERVICE"
    fi
}

# Function to enable a user service
enable_user_service() {
    SERVICE="$1"
    if systemctl --user is-enabled --quiet "$SERVICE"; then
        echo "✔️ $SERVICE is already enabled (user)"
    else
        echo "➕ Enabling $SERVICE (user)..."
        systemctl --user enable "$SERVICE"
    fi
}

# Function to start a user service
start_user_service() {
    SERVICE="$1"
    if systemctl --user is-active --quiet "$SERVICE"; then
        echo "✔️ $SERVICE is already running (user)"
    else
        echo "🚀 Starting $SERVICE (user)..."
        systemctl --user start "$SERVICE"
    fi
}

echo "🔧 Setting up audio services..."

# 1. Enable system-wide speaker safety
enable_system_service "speakersafetyd.service"

# 2. Enable user services
enable_user_service "pipewire"
enable_user_service "pipewire-pulse.service"
enable_user_service "wireplumber.service"

# 3. Start user services
start_user_service "pipewire"
start_user_service "pipewire-pulse.service"
start_user_service "wireplumber.service"

echo "✅ All done!"

