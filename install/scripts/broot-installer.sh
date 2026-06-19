#!/usr/bin/env bash

set -euo pipefail

# ─────────────────────────────────────
# Detect distro
# ─────────────────────────────────────
if [[ -f /etc/os-release ]]; then
    . /etc/os-release
else
    echo "Cannot detect Linux distribution."
    exit 1
fi

DISTRO="${ID,,}"

# ─────────────────────────────────────
# Check if cargo exists
# ─────────────────────────────────────
if ! command -v cargo >/dev/null 2>&1; then
    echo "Rust/Cargo is not installed."
    echo "Please install rustup first:"
    echo
    echo "  curl https://sh.rustup.rs -sSf | sh"
    echo
    exit 1
fi

# ─────────────────────────────────────
# Update Rust toolchain
# ─────────────────────────────────────
echo "Updating Rust toolchain..."
rustup update

# ─────────────────────────────────────
# Install dependencies
# ─────────────────────────────────────
case "$DISTRO" in
    arch|endeavouros|manjaro)
        echo "Detected Arch-based system."
        echo "Installing libxcb..."

        sudo pacman -Syu --noconfirm libxcb
        ;;

    fedora)
        echo "Detected Fedora."
        echo "Installing libxcb..."

        sudo dnf install -y libxcb
        ;;

    *)
        echo "Unsupported distribution: $DISTRO"
        echo "Please install libxcb manually."
        exit 1
        ;;
esac

# ─────────────────────────────────────
# Install broot
# ─────────────────────────────────────
echo "Installing broot..."

cargo install --locked --features clipboard broot

# ─────────────────────────────────────
# Done
# ─────────────────────────────────────
echo
echo "broot installed successfully!"
echo
echo "You can initialize shell integration with:"
echo
echo "  broot --install"
