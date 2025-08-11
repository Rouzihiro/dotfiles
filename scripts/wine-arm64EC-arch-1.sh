#!/bin/bash
set -euo pipefail

# Variables
WORKDIR="$HOME/wine-arm64ec"
ARCHIVE_URL="https://github.com/lacamar/wine-arm64ec-rpm/releases/download/wine-arm64ec-07.07.2025-1/wine-10.8.arm64ec-1-07.07.2025.tar.gz"
EXTRACT_DIR="$WORKDIR/wine-arm"
PKGROOT="$EXTRACT_DIR/pkgroot"

# Install rpm2cpio if missing
if ! command -v rpm2cpio &>/dev/null; then
  echo "rpm2cpio not found, installing rpm-org..."
  sudo pacman -S --noconfirm rpm-org
fi

# Create working directory
mkdir -p "$WORKDIR"
cd "$WORKDIR"

# Download archive if not already present
if [ ! -f "wine-10.8.arm64ec-1-07.07.2025.tar.gz" ]; then
  echo "Downloading Wine ARM64 archive..."
  wget "$ARCHIVE_URL"
else
  echo "Archive already downloaded."
fi

# Extract archive
echo "Extracting archive..."
tar -xzf wine-10.8.arm64ec-1-07.07.2025.tar.gz

cd "$EXTRACT_DIR"

# Remove old pkgroot if exists
rm -rf "$PKGROOT"
mkdir -p "$PKGROOT"

# Extract all RPMs into pkgroot
for rpm in *.rpm; do
  echo "Extracting $rpm ..."
  rpm2cpio "$rpm" | (cd "$PKGROOT" && cpio -idmv)
done

# Fix lib64 to lib
if [ -d "$PKGROOT/usr/lib64" ]; then
  mkdir -p "$PKGROOT/usr/lib"
  mv "$PKGROOT/usr/lib64/"* "$PKGROOT/usr/lib/"
  rmdir "$PKGROOT/usr/lib64"
fi

# Copy files to system (ask for sudo)
echo "Copying files to system..."
sudo cp -a "$PKGROOT/"* /

# Create symlinks for Wine executables
echo "Creating symlinks..."
BIN_DIR="/usr/bin"
WINE_LIB_DIR="/usr/lib/wine/aarch64-unix"

sudo ln -sf "$WINE_LIB_DIR/wine" "$BIN_DIR/wine"
sudo ln -sf "$WINE_LIB_DIR/wineserver" "$BIN_DIR/wineserver"
sudo ln -sf "$WINE_LIB_DIR/wineboot" "$BIN_DIR/wineboot"
sudo ln -sf "$WINE_LIB_DIR/wine64" "$BIN_DIR/wine64"
# Only create winecfg symlink if the file exists
if [ -f "$WINE_LIB_DIR/winecfg" ]; then
  sudo ln -sf "$WINE_LIB_DIR/winecfg" "$BIN_DIR/winecfg"
fi

echo "Wine ARM64EC installation complete!"
echo "Run 'wine --version' to verify."

