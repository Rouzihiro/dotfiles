#!/bin/bash
set -e

# Change this to your RPM folder path
RPM_DIR="$HOME/wine-arm"

# Temp directory for extraction
TMPDIR="/tmp/wine-rpm-extract"

echo "Cleaning temp extraction folder..."
sudo rm -rf "$TMPDIR"
mkdir -p "$TMPDIR"

echo "Extracting RPM packages..."
for rpm in "$RPM_DIR"/*.rpm; do
  echo "Extracting $(basename "$rpm")..."
  rpm2cpio "$rpm" | (cd "$TMPDIR" && cpio -idmv)
done

echo "Copying extracted files to /usr/ ..."
sudo cp -rv "$TMPDIR/usr/"* /usr/

echo "Fixing broken wineserver symlink..."
if [ -L /usr/bin/wineserver ]; then
  sudo rm /usr/bin/wineserver
fi
sudo ln -s /usr/lib/wine/aarch64-unix/wineserver /usr/bin/wineserver

echo "Fixing broken wine symlink (if any)..."
if [ ! -x /usr/bin/wine ]; then
  sudo ln -s /usr/lib/wine/wine /usr/bin/wine
fi

echo "Creating symlink for winecfg..."
# Check if winecfg exists inside /usr/lib/wine or similar
if [ ! -f /usr/bin/winecfg ]; then
  WINECFG_PATH=$(find /usr/lib/wine -name winecfg 2>/dev/null | head -n1)
  if [ -n "$WINECFG_PATH" ]; then
    sudo ln -s "$WINECFG_PATH" /usr/bin/winecfg
  else
    echo "Warning: winecfg binary not found. You may need to build or install it separately."
  fi
fi

echo "Done. Wine should be installed now."

echo "Try running: wine --version"

