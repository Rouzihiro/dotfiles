# 1. Download
wget https://github.com/mstorsjo/llvm-mingw/releases/download/20250709/llvm-mingw-20250709-ucrt-ubuntu-22.04-aarch64.tar.xz

# 2. Extract
tar -xf llvm-mingw-20250709-ucrt-ubuntu-22.04-aarch64.tar.xz

# 3. Add to PATH for this session
cd llvm-mingw-20250709-ucrt-ubuntu-22.04-aarch64
export PATH="$PWD/bin:$PATH"

# 4. Test
aarch64-w64-mingw32-gcc --version

