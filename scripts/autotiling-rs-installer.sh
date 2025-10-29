#!/bin/bash
# Minimal autotiling-rs installer for Sway (Fedora)

set -e  # Exit on error

# Config
INSTALL_DIR="$HOME/.local/bin/"
REPO_URL="https://github.com/ammgws/autotiling-rs.git"

# Install build dependencies
echo "Installing dependencies..."
sudo dnf install -y \
    rust cargo \
    make gcc \
    libxkbcommon-devel \
    wayland-devel \
    wayland-protocols-devel

# Clone or update repository
if [ -d "autotiling-rs" ]; then
    echo "Updating repository..."
    cd autotiling-rs
    git pull
else
    echo "Cloning repository..."
    git clone "$REPO_URL"
    cd autotiling-rs
fi

# Build for Sway
echo "Building for Sway (release mode)..."
cargo build --release

# Install binary
echo "Installing to $INSTALL_DIR..."
mkdir -p "$INSTALL_DIR"
install -m 755 target/release/autotiling-rs "$INSTALL_DIR"/

# Verify
echo "Installation complete. Binary info:"
"$INSTALL_DIR"/autotiling-rs --version

# Check PATH
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    echo "Note: ~/bin is not in your PATH. Add this to your shell config:"
    echo 'export PATH="$HOME/.local/bin:$PATH"'
fi
