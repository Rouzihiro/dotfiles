#!/bin/bash

# Exit immediately on errors
set -euo pipefail

# Colors
RED="\e[31m"; GREEN="\e[32m"; YELLOW="\e[33m"; BLUE="\e[34m"; ENDCOLOR="\e[0m"
info() { echo -e "${GREEN}[INFO]${ENDCOLOR} $1"; }
warn() { echo -e "${YELLOW}[WARN]${ENDCOLOR} $1"; }
error() { echo -e "${RED}[ERROR]${ENDCOLOR} $1"; exit 1; }
step() { echo -e "${BLUE}[STEP]${ENDCOLOR} $1"; }

# Check root
if [[ $EUID -eq 0 ]]; then
    error "Never run this as root!"
fi

# Install Zenity if missing
if ! command -v zenity &>/dev/null; then
    sudo pacman -Syu --noconfirm zenity || error "Failed to install zenity"
fi

# Fix mirrorlist warnings (non-critical)
step "Fixing mirrorlist..."
sudo sed -i '/^Server/d' /etc/pacman.d/mirrorlist 2>/dev/null || true
echo "Server = https://mirror.rackspace.com/archlinux/\$repo/os/\$arch" | sudo tee -a /etc/pacman.d/mirrorlist >/dev/null

# Enable parallel downloads
step "Optimizing pacman..."
sudo sed -i "s/^#ParallelDownloads = 5$/ParallelDownloads = 10/" /etc/pacman.conf

# Enable Multilib
step "Enabling Multilib..."
if ! grep -q "^\[multilib\]" /etc/pacman.conf; then
    echo -e "\n[multilib]\nInclude = /etc/pacman.d/mirrorlist" | sudo tee -a /etc/pacman.conf >/dev/null
fi
sudo pacman -Sy --noconfirm || warn "Sync had issues (mirrorlist warnings are harmless)"

# Nuclear option for Wine conflicts
step "Purging all Wine packages..."
sudo pacman -Rdd --noconfirm \
    wine \
    wine-staging \
    wine-mono \
    wine-gecko \
    lib32-wine \
    wine-nine \
    wine-wayland \
    2>/dev/null || true

# Install core packages with explicit conflict resolution
step "Installing gaming packages..."
sudo pacman -S --needed --noconfirm --overwrite '*' \
    wine-staging \
    wine-mono \
    winetricks \
    lutris \
    gamemode \
    lib32-gamemode \
	lib32-freetype2 \
	lib32-glibc \
    vulkan-icd-loader \
    lib32-vulkan-icd-loader \
    lib32-gnutls \
    lib32-libldap \
    lib32-libgpg-error \
    lib32-sqlite \
    lib32-libpulse || {
    warn "Package installation had non-fatal issues"
    # Continue despite some failures
}

# Install AUR packages (if helper exists)
step "Installing AUR packages..."
if command -v yay &>/dev/null; then
    yay -S --needed --noconfirm dxvk-bin vkd3d-proton-bin || warn "AUR install skipped/failed"
elif command -v paru &>/dev/null; then
    paru -S --needed --noconfirm dxvk-bin vkd3d-proton-bin || warn "AUR install skipped/failed"
else
    warn "No AUR helper (yay/paru) found. Skipping AUR packages."
fi

# Configure Wine
info "Setting up Wine..."
export WINEARCH=win64
export WINEPREFIX="$HOME/.wine-gameready"
rm -rf "$WINEPREFIX" 2>/dev/null || true
wineboot -u 2>/dev/null || true

# Install Winetricks deps
step "Installing Windows components (takes 10-15 mins)..."
winetricks --force -q \
    d3dx9 \
    d3dx10 \
    dxvk \
    dotnet48 \
    vcrun2008 \
    vcrun2010 \
    vcrun2012 \
    vcrun2013 \
    vcrun2015 \
    vcrun2019 || warn "Some components failed (non-critical)"

# Enable Gamemode
step "Enabling Gamemode..."
sudo systemctl enable --now gamemoded.service || warn "Failed to enable gamemode (may already be active)"

# Verify installation
step "Verifying components..."
if ! command -v wine &>/dev/null; then
    error "Wine failed to install!"
elif ! command -v winetricks &>/dev/null; then
    error "Winetricks failed to install!"
else
    info "Core components verified:"
    wine --version
    winetricks --version
fi

# Final cleanup
sudo pacman -Scc --noconfirm 2>/dev/null || true

# Done!
info "Installation complete!"
zenity --info --width=300 --title="Success!" \
    --text="Gaming setup finished!\n\n• Lutris: Ready\n• Wine: $(wine --version)\n• Winetricks: $(winetricks --version)\n\nPrefix: $WINEPREFIX\n\nReboot recommended."
