#!/bin/bash
# setup-ryujinx-launcher.sh — auto-detect latest publish folder and create launcher

# 1. Find newest publish directory automatically
PUBLISH_DIR=$(find "$HOME/Games/ryujinx/src/Ryujinx/bin/Release" -type d -path "*/linux-arm64/publish" | sort -V | tail -n 1)

if [[ -z "$PUBLISH_DIR" ]]; then
    echo "❌ Could not find Ryujinx publish directory."
    exit 1
fi

# 2. Define launcher and desktop file locations
LAUNCHER="$HOME/bin/ryujinx"
DESKTOP_FILE="$HOME/.local/share/applications/ryujinx.desktop"

# 3. Ensure ~/bin exists
mkdir -p "$HOME/bin"

# 4. Create launcher script
cat > "$LAUNCHER" <<EOF
#!/bin/bash
"$PUBLISH_DIR/Ryujinx" "\$@"
EOF
chmod +x "$LAUNCHER"

# 5. Create .desktop entry
mkdir -p "$(dirname "$DESKTOP_FILE")"
cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Name=Ryujinx
Exec=$LAUNCHER
Icon=ryujinx
Type=Application
Categories=Game;
EOF

# 6. Refresh desktop database
update-desktop-database "$(dirname "$DESKTOP_FILE")"

echo "✅ Launcher created at $LAUNCHER"
echo "✅ Desktop entry created at $DESKTOP_FILE"
echo "📂 Ryujinx path: $PUBLISH_DIR"

