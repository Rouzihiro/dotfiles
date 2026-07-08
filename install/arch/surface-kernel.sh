#!/bin/bash
set -euo pipefail

echo "======================================"
echo " Surface Book 2 Arch Setup"
echo "======================================"

# -----------------------------
# 1. Time sync
# -----------------------------
echo "[1/8] Enabling time sync..."

sudo timedatectl set-ntp true


# -----------------------------
# 2. Update base system
# -----------------------------
echo "[2/8] Updating Arch..."

sudo pacman -Syu --noconfirm


# -----------------------------
# 3. Base firmware + services
# -----------------------------
echo "[3/8] Installing firmware/network/audio..."

sudo pacman -S --needed --noconfirm \
    linux-firmware \
    networkmanager \
    bluez \
    bluez-utils \
    pipewire \
    pipewire-pulse \
    wireplumber \
    curl


sudo systemctl enable --now NetworkManager
sudo systemctl enable --now bluetooth


# -----------------------------
# 4. Add linux-surface repository
# -----------------------------
echo "[4/8] Adding linux-surface repo..."

if ! grep -q "\[linux-surface\]" /etc/pacman.conf; then

sudo tee -a /etc/pacman.conf >/dev/null <<EOF

[linux-surface]
Server = https://pkg.surfacelinux.com/arch/
EOF

fi


# -----------------------------
# 5. Import Surface signing key
# -----------------------------
echo "[5/8] Importing linux-surface key..."

curl -fsSL \
https://raw.githubusercontent.com/linux-surface/linux-surface/master/pkg/keys/surface.asc \
| sudo pacman-key --add -

sudo pacman-key --lsign-key 56C464BAAC421453


# -----------------------------
# 6. Install Surface kernel
# -----------------------------
echo "[6/8] Installing linux-surface kernel..."

sudo pacman -Syu --noconfirm

sudo pacman -S --needed --noconfirm \
    linux-surface \
    linux-surface-headers \
    iptsd


# -----------------------------
# 7. Bootloader refresh
# -----------------------------
echo "[7/8] Updating boot files..."

sudo mkinitcpio -P


if command -v grub-mkconfig >/dev/null; then
    sudo grub-mkconfig -o /boot/grub/grub.cfg
fi


# -----------------------------
# 8. Minimal Wayland tools
# -----------------------------
echo "[8/8] Installing Wayland basics..."

sudo pacman -S --needed --noconfirm \
    kitty \
    foot \
    polkit \
    mesa \
    vulkan-intel


echo "======================================"
echo " DONE"
echo " Reboot into linux-surface kernel"
echo "======================================"
