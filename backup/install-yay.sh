#!/bin/bash

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

log_info()  { echo -e "${GREEN}[INFO]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Check if yay is already installed
if command -v yay &>/dev/null; then
    log_info "yay is already installed."
    exit 0
fi

log_info "Installing yay (AUR helper)..."

# Install dependencies
sudo pacman -S --needed --noconfirm git base-devel || {
    log_error "Failed to install required packages."
    exit 1
}

# Clone and build yay
tmp_dir=$(mktemp -d)
git clone https://aur.archlinux.org/yay.git "$tmp_dir/yay" || {
    log_error "Failed to clone yay repo."
    exit 1
}
cd "$tmp_dir/yay" || exit 1
makepkg -si --noconfirm || {
    log_error "Failed to build and install yay."
    exit 1
}

log_info "yay installed successfully!"