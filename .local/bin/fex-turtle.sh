#!/bin/bash
# fex-turtle.sh
# Launch TurtleWoW under FEX + Proton/Wine

# Set Proton/Wine paths
export PROTON_PATH="$HOME/.local/share/Steam/steamapps/common/Proton 10.0"
export WINE="$PROTON_PATH/files/bin/wine"
export WINESERVER="$PROTON_PATH/files/bin/wineserver"

# Set Wine prefix (where the game is installed)
export PROTON_PREFIX="$HOME/.proton/pfx"

# Optional: disable unnecessary Wine debug messages
export WINEDEBUG="-all"

# Optional: override some DLLs to prevent crashes
export WINEDLLOVERRIDES="dwmapi,bthfake,n"

# Disable Wine ESYNC (can help under FEX)
export WINEESYNC=0

# Set working directory to the game folder
cd "$PROTON_PREFIX/drive_c/TurtleWoW" || exit 1

# Launch the game in a virtual desktop (change resolution if needed)
"$WINE" explorer /desktop=TurtleWoW,1280x720 turtle-wow.exe
