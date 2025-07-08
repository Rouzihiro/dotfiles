#!/bin/bash
env \
  WINE_FULLSCREEN_FOCUS=1 \
  WLR_DPI=96 \
  WINEPREFIX="$HOME/.wine" \
  wine explorer /desktop=WoW,2560x1600 /home/rey/Games/Stormforge/Wow-SF.exe

