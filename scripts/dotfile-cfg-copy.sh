#!/bin/bash

# Restore dotfiles and configs from ~/dotfiles/ to system

echo "♻️  Restoring dotfiles and configs from ~/dotfiles/..."

# --- 1. Restore .config ---
echo "🔄 Restoring ~/.config/..."
rsync -av --delete \
    --exclude='Ryujinx' \
    --exclude='BraveSoftware' \
    --exclude='Cache' \
    --exclude='Trash' \
    --exclude='Spotify' \
    --exclude='discord' \
    --exclude='qBittorrent' \
    --exclude='libreoffice' \
    --exclude='warp-terminal' \
    "$HOME/dotfiles/.config/" "$HOME/.config/"

# --- 2. Restore shell dotfiles ---
echo "🔄 Restoring shell dotfiles to ~/"
while IFS= read -r file; do
    src="$HOME/dotfiles/$file"
    dst="$HOME/$file"
    [ -f "$src" ] && rsync -av "$src" "$dst" && echo "  ✓ $file"
done <<EOF
.bashrc
.bash_profile
.bash_logout
.zshrc
.zprofile
.aliases
.aliases-functions
.aliases-arch
.aliases-fedora
.mbsyncrc
.msmtprc
.gitconfig
EOF

# --- 3. Restore bin/ folder ---
DOTFILES_BIN="$HOME/dotfiles/bin"
TARGET_BIN="$HOME/bin"
if [ -d "$DOTFILES_BIN" ]; then
    echo "🔄 Restoring ~/bin/ from dotfiles..."
    mkdir -p "$TARGET_BIN"
    rsync -av --delete "$DOTFILES_BIN/" "$TARGET_BIN/"
    echo "  ✓ bin/ → ~/bin/"
else
    echo "⚠️  $DOTFILES_BIN not found, skipping..."
fi

echo -e "\n✅ Done! Dotfiles restored from: $HOME/dotfiles/"

