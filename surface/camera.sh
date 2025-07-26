#!/bin/bash
# linux-surface-camera.sh
# Sets up the Surface camera on Arch Linux (assumes linux-surface kernel is already installed)

set -e

# Ensure the script is run with root privileges
if [[ $EUID -ne 0 ]]; then
    echo "[!] Please run this script as root (e.g., with sudo)"
    exit 1
fi

echo "[*] Refreshing package database..."
pacman -Sy --noconfirm

echo "[*] Installing libcamera and related tools..."
pacman -S --noconfirm libcamera libcamera-tools 

#v4l-utils

echo "[✓] Setup complete. You can test the camera using 'qcam'."

