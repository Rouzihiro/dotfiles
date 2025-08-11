#!/usr/bin/env bash
set -euo pipefail

# Variables
LLVM_MINGW_VERSION="20250709"
LLVM_MINGW_ARCHIVE="llvm-mingw-${LLVM_MINGW_VERSION}-ucrt-ubuntu-22.04-aarch64.tar.xz"
LLVM_MINGW_URL="https://github.com/mstorsjo/llvm-mingw/releases/download/${LLVM_MINGW_VERSION}/${LLVM_MINGW_ARCHIVE}"
WORKDIR="$HOME/build-wine/wine"
LLVM_MINGW_DIR="$WORKDIR/llvm-mingw-${LLVM_MINGW_VERSION}-ucrt-ubuntu-22.04-aarch64"

# Step 1: Download llvm-mingw if not already downloaded
mkdir -p "$WORKDIR"
cd "$WORKDIR"
if [[ ! -d "$LLVM_MINGW_DIR" ]]; then
  echo "Downloading llvm-mingw ${LLVM_MINGW_VERSION}..."
  wget -c "$LLVM_MINGW_URL"
  echo "Extracting llvm-mingw..."
  tar -xf "$LLVM_MINGW_ARCHIVE"
fi

# Step 2: Clean previous build and create build directory
rm -rf build64
mkdir build64
cd build64

# Step 3: Configure Wine build with llvm-mingw and clang from llvm-mingw
echo "Configuring Wine build..."
CC="$LLVM_MINGW_DIR/bin/clang"
CXX="$LLVM_MINGW_DIR/bin/clang++"

../configure --enable-win64 \
  --with-mingw="$LLVM_MINGW_DIR" \
  CC="$CC" \
  CXX="$CXX"

# Step 4: Add llvm-mingw's winebuild tools to PATH
export PATH="$LLVM_MINGW_DIR/tools/winebuild:$PATH"

# Step 5: Build Wine using all available cores
echo "Building Wine..."
make -j"$(nproc)"

echo "Wine build complete!"

# Step 6: Instructions for the user
cat <<EOF

Setup complete!

You can now use your freshly built Wine. To run Wine, you may want to set:

  export PATH="$LLVM_MINGW_DIR/tools/winebuild:\$PATH"

and then run Wine with your build, for example:

  $WORKDIR/build64/winecfg

If you want a clean 64-bit Wine prefix, try:

  WINEARCH=win64 WINEPREFIX=\$HOME/.wine64 $WORKDIR/build64/winecfg

EOF

