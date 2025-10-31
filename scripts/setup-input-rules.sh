#!/usr/bin/env bash
# setup-uinput.sh
# Makes /dev/uinput accessible to your user

set -e

USER_NAME=${SUDO_USER:-$USER}

echo ">>> Loading uinput kernel module..."
sudo modprobe uinput

echo ">>> Creating 'input' group if it doesn't exist..."
sudo groupadd -f input

echo ">>> Adding user '$USER_NAME' to 'input' group..."
sudo usermod -aG input "$USER_NAME"

echo ">>> Creating udev rule for /dev/uinput..."
UDEV_FILE="/etc/udev/rules.d/99-uinput.rules"
if [[ ! -f "$UDEV_FILE" ]]; then
    echo 'KERNEL=="uinput", MODE="0660", GROUP="input"' | sudo tee "$UDEV_FILE" >/dev/null
    echo "udev rule created at $UDEV_FILE"
else
    echo "udev rule already exists at $UDEV_FILE"
fi

echo ">>> Reloading udev rules and triggering..."
sudo udevadm control --reload-rules
sudo udevadm trigger

echo ">>> Done! Please log out and back in to apply group changes."
echo ">>> You can check /dev/uinput permissions with: stat /dev/uinput"
