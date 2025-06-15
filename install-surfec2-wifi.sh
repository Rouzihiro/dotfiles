#!/bin/bash

set -e

echo "[+] Installing essential Wi-Fi packages for Surface Book 2..."

sudo pacman -Syu --noconfirm \
    linux-firmware \
    iwd \
    iw \
    wireless_tools \
    wpa_supplicant \
    sudo

echo "[+] Enabling iwd (iwctl) systemd service..."
sudo systemctl enable --now iwd

# Confirm iwd is running
echo "[+] Checking iwd status..."
sudo systemctl status iwd --no-pager

# Optional: install linux-surface kernel
read -p "[?] Do you want to install the linux-surface kernel for better hardware support? (y/N): " yn
if [[ "$yn" =~ ^[Yy]$ ]]; then
    echo "[+] Adding Surface Linux repository..."

    sudo pacman-key --recv-key 56C464BAAC421453 --keyserver hkps://keyserver.ubuntu.com
    sudo pacman-key --lsign-key 56C464BAAC421453

    echo "[linux-surface]
Server = https://pkg.surfacelinux.com/arch/" | sudo tee -a /etc/pacman.conf

    echo "[+] Installing linux-surface kernel and IP sensor support..."
    sudo pacman -Syu --noconfirm linux-surface linux-surface-headers iptsd

    echo "[+] Enabling touchscreen/stylus input (iptsd)..."
    sudo systemctl enable --now iptsd
else
    echo "[+] Skipping linux-surface. Make sure your kernel keeps working with your Wi-Fi."
fi

echo "[✓] Setup complete. Your Wi-Fi (iwctl) should work after reboot."

