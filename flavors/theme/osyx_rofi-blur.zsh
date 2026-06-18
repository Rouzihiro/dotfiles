#!/usr/bin/env zsh

BACKGROUNDS_DIR="$HOME/dotfiles/flavors/backgrounds"
OUTPUT="$HOME/.cache/osyx/bg-rofi-blur.png"
THEME="${1:-$(cat "${XDG_STATE_HOME:-$HOME/.local/state}/osyx/current" 2>/dev/null)}"

mkdir -p "${OUTPUT:h}"

wallpaper=""
for ext in jpg png webp; do
    f="$BACKGROUNDS_DIR/$THEME.$ext"
    [[ -f "$f" || -L "$f" ]] && wallpaper="$f" && break
done

[[ -z "$wallpaper" ]] && exit 1

magick "$(readlink -f "$wallpaper")" \
    -resize 1366x768^ -gravity center -extent 1366x768 -blur 0x8 \
    "$OUTPUT"
