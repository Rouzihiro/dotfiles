#!/bin/bash
set -euo pipefail

WINE_VERSION="10.12"
ARCHIVE_URL="https://dl.winehq.org/wine/source/10.x/wine-${WINE_VERSION}.tar.xz"
WORKDIR="$HOME/wine-src"
INSTALL_PREFIX="/usr/local"

# Install dependencies for building wine on Arch ARM64

sudo pacman -Syu --noconfirm \
 base-devel git wget \
 freetype2 fontconfig libx11 libxext libxrender libxrandr libxi libxcomposite libxdamage libxfixes libxss libxtst \
 mesa mesa-libgl vulkan-icd-loader vulkan-tools vulkan-headers python python-pytest

mkdir -p "$WORKDIR"
cd "$WORKDIR"

if [ ! -f "wine-${WINE_VERSION}.tar.xz" ]; then
  wget "$ARCHIVE_URL"
fi

tar -xf "wine-${WINE_VERSION}.tar.xz"
cd "wine-${WINE_VERSION}"

./configure --prefix="$INSTALL_PREFIX"
make -j$(nproc)
sudo make install

# Symlink wine executables to /usr/bin
sudo ln -sf "$INSTALL_PREFIX/bin/wine" /usr/bin/wine
sudo ln -sf "$INSTALL_PREFIX/bin/winecfg" /usr/bin/winecfg
sudo ln -sf "$INSTALL_PREFIX/bin/wineserver" /usr/bin/wineserver

echo "Wine $WINE_VERSION installed successfully."
wine --version

