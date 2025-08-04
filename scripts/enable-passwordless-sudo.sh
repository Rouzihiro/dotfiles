#!/bin/bash

USER="rey"
SUDOERS_LINE="$USER ALL=(ALL:ALL) NOPASSWD:ALL"
SUDOERS_FILE="/etc/sudoers.d/$USER-nopasswd"

# Check if already exists
if sudo grep -Fxq "$SUDOERS_LINE" "$SUDOERS_FILE" 2>/dev/null; then
    echo "Passwordless sudo already enabled for $USER."
    exit 0
fi

# Create the sudoers snippet file
echo "Enabling passwordless sudo for $USER..."
echo "$SUDOERS_LINE" | sudo tee "$SUDOERS_FILE" > /dev/null

# Set correct permissions
sudo chmod 0440 "$SUDOERS_FILE"

# Check with visudo
if sudo visudo -cf "$SUDOERS_FILE"; then
    echo "✅ Passwordless sudo enabled successfully for $USER."
else
    echo "❌ visudo check failed. Removing invalid sudoers file."
    sudo rm "$SUDOERS_FILE"
    exit 1
fi

