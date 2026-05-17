#!/bin/bash
set -euo pipefail

echo "======================================"
echo " Surface Arch Setup (Unified Script)"
echo "======================================"

# -----------------------------
# 1. Ensure correct system state
# -----------------------------
echo "[1/7] Syncing time (IMPORTANT for PGP)..."
sudo timedatectl set-ntp true

# -----------------------------
# 2. Fix keyring (critical)
# -----------------------------
echo "[2/7] Resetting pacman keyring..."

sudo pacman-key --init
sudo pacman-key --populate archlinux

sudo pacman -Sy --noconfirm archlinux-keyring

# -----------------------------
# 3. Base firmware + networking
# -----------------------------
echo "[3/7] Installing base firmware + network tools..."

sudo pacman -S --noconfirm \
    linux-firmware \
    networkmanager \
    bluez \
    bluez-utils \
    pipewire \
    pipewire-pulse \
    wireplumber

sudo systemctl enable --now NetworkManager
sudo systemctl enable --now bluetooth

# -----------------------------
# 4. Surface Linux repo (safe)
# -----------------------------
echo "[4/7] Adding linux-surface repo..."

if ! grep -q "\[linux-surface\]" /etc/pacman.conf; then
    echo -e "\n[linux-surface]
Server = https://pkg.surfacelinux.com/arch/" | sudo tee -a /etc/pacman.conf
fi

# -----------------------------
# 5. Surface key (modern safe method)
# -----------------------------
echo "[5/7] Importing Surface GPG key..."

KEY_URL="https://raw.githubusercontent.com/linux-surface/linux-surface/master/pkg/keys/surface.asc"
KEY_FILE="/tmp/surface.asc"

curl -fsSL "$KEY_URL" -o "$KEY_FILE"

sudo pacman-key --add "$KEY_FILE"
sudo pacman-key --lsign-key 56C464BAAC421453

# -----------------------------
# 6. Install Surface kernel
# -----------------------------
echo "[6/7] Installing linux-surface kernel..."

sudo pacman -Sy --noconfirm
sudo pacman -S --noconfirm \
    linux-surface \
    linux-surface-headers \
    iptsd

# Optional Wi-Fi firmware (safe fallback)
sudo pacman -S --noconfirm linux-firmware-marvell || true

# -----------------------------
# 7. Desktop base (Hyprland-ready)
# -----------------------------
echo "[7/7] Installing minimal desktop stack..."

sudo pacman -S --noconfirm \
    waybar \
    kitty \
		foot \
    polkit

echo "======================================"
echo " DONE"
echo " Reboot recommended"
echo "======================================"
