#!/bin/bash

TARGET_DIR="$HOME/.local/share/icons/hicolor/256x256"
SOURCE_DIR="$HOME/Pictures/icons"

# Create the parent target directory if it doesn't exist
mkdir -p "$TARGET_DIR"

# Remove existing 'apps' folder or symlink if present
rm -rf "$TARGET_DIR/apps"

# Create symlink named 'apps' pointing to your ~/Pictures/icons
ln -s "$SOURCE_DIR" "$TARGET_DIR/apps"

echo "Symlinked entire icons folder:"
ls -l "$TARGET_DIR"
