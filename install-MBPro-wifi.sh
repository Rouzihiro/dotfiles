#!/bin/bash

set -e

echo "[*] Installing required packages..."
sudo pacman -S --noconfirm wget b43-fwcutter networkmanager

echo "[*] Enabling and starting NetworkManager..."
sudo systemctl enable --now NetworkManager

echo "[*] Downloading Broadcom firmware..."
wget https://www.lwfinger.com/b43-firmware/broadcom-wl-5.100.138.tar.bz2

echo "[*] Extracting firmware..."
tar -xjf broadcom-wl-5.100.138.tar.bz2

cd broadcom-wl-5.100.138

echo "[*] Extracting firmware to /lib/firmware..."
sudo b43-fwcutter -w /lib/firmware wl_apsta.o

echo "[*] Checking firmware files..."
ls /lib/firmware/b43/

echo "[*] Loading b43 kernel module..."
sudo modprobe b43

echo "[✓] Done. You can now launch the Wi-Fi manager:"
echo ""
echo "    nmtui"
echo ""

