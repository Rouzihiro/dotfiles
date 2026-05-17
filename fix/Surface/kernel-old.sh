#!/bin/bash
# linux-surface-setup.sh
# Sets up the Linux Surface kernel on Arch Linux

set -e

KEY_ID="56C464BAAC421453"
PACMAN_CONF="/etc/pacman.conf"
REPO_ENTRY="[linux-surface]
Server = https://pkg.surfacelinux.com/arch/"

echo "[*] Adding Linux Surface GPG key..."
curl -s https://raw.githubusercontent.com/linux-surface/linux-surface/master/pkg/keys/surface.asc \
    | sudo pacman-key --add -

echo "[*] Verifying key fingerprint..."
sudo pacman-key --finger "$KEY_ID"

echo "[*] Locally signing the key..."
sudo pacman-key --lsign-key "$KEY_ID"

if ! grep -q "linux-surface" "$PACMAN_CONF"; then
    echo "[*] Adding linux-surface repository to $PACMAN_CONF..."
    echo -e "\n$REPO_ENTRY" | sudo tee -a "$PACMAN_CONF" > /dev/null
else
    echo "[*] Repository already present in $PACMAN_CONF. Skipping..."
fi

echo "[*] Refreshing package database..."
sudo pacman -Syu --noconfirm

echo "[*] Installing linux-surface kernel and dependencies..."
sudo pacman -S --noconfirm linux-surface linux-surface-headers iptsd

echo "[*] Optional: Installing WiFi firmware for Surface Pro 4–6, Book 1–2, Laptop 1–2..."
sudo pacman -S --noconfirm linux-firmware-marvell || echo "Skipping firmware if not needed."

echo "[*] NOTE: Please install 'libwacom-surface' from the AUR manually."
echo "[*] You can use an AUR helper like yay or manually clone and build it from:"
echo "    https://aur.archlinux.org/packages/libwacom-surface"

echo "[✓] Setup complete. Reboot to start using the linux-surface kernel."