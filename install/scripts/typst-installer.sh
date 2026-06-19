#!/bin/bash

# Typst & Tinymist Installation Script
echo "========================================="
echo "Installing Typst & Tinymist for Neovim"
echo "========================================="

# Update system and install dependencies
echo "📦 Installing system dependencies..."
sudo dnf install -y openssl-devel gcc make pkgconfig cargo

# Install Typst CLI
echo "🚀 Installing Typst CLI..."
cargo install typst-cli --locked

# Install Tinymist CLI (LSP server)
echo "💡 Installing Tinymist CLI (LSP server)..."
cargo install --git https://github.com/Myriad-Dreamin/tinymist --locked tinymist-cli

# Verify installations
echo "✅ Verifying installations..."
echo ""
echo "Typst version:"
typst --version || echo "Typst not found in PATH"
echo ""
echo "Tinymist version:"
tinymist --version || echo "Tinymist not found in PATH"

echo ""
echo "========================================="
echo "Installation Complete!"
echo ""
echo "Next steps in Neovim:"
echo "1. Open Neovim"
echo "2. Run: :MasonInstall tinymist"
echo ""
echo "Why Mason too? Mason ensures the LSP is in the"
echo "right location for Neovim's package manager."
echo "========================================="
