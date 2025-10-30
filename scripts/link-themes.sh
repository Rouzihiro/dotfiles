#!/bin/bash

# --- Icons symlink ---
TARGET_ICON_DIR="$HOME/.local/share/icons/hicolor/256x256"
SOURCE_ICON_DIR="$HOME/Pictures/icons"

# Create the parent target directory if it doesn't exist
mkdir -p "$TARGET_ICON_DIR"

# Remove existing 'apps' folder or symlink if present
rm -rf "$TARGET_ICON_DIR/apps"

# Create symlink named 'apps' pointing to your ~/Pictures/icons
ln -s "$SOURCE_ICON_DIR" "$TARGET_ICON_DIR/apps"

echo "Symlinked entire icons folder:"
ls -l "$TARGET_ICON_DIR"

# --- Themes symlink ---
THEMES_SRC="$HOME/dotfiles/.themes"
THEMES_DEST="$HOME/.themes"

# Backup existing .themes if it exists
if [ -e "$THEMES_DEST" ] || [ -L "$THEMES_DEST" ]; then
    echo "Backing up existing $THEMES_DEST to ${THEMES_DEST}.backup"
    mv "$THEMES_DEST" "${THEMES_DEST}.backup"
fi

# Create symlink for .themes
ln -s "$THEMES_SRC" "$THEMES_DEST"
echo "Symlinked .themes folder:"
ls -l "$THEMES_DEST"
