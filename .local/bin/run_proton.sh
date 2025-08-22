#!/bin/bash
# ----------------------------
# Run any Windows installer or winecfg under Proton 10 + FEX
# ----------------------------

# Set Proton paths
PROTON_PREFIX="$HOME/.proton/compatdata/10"
PROTON_PATH="$HOME/.local/share/Steam/steamapps/common/Proton 10.0"
WINE="$PROTON_PATH/files/bin/wine"
WINESERVER="$PROTON_PATH/files/bin/wineserver"

# Ensure the prefix exists
mkdir -p "$PROTON_PREFIX"

# Launch command inside Proton prefix
# Usage: ./run_proton.sh winecfg
"$WINE" "$@" WINEPREFIX="$PROTON_PREFIX"

