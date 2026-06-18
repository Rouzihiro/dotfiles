#!/usr/bin/env zsh

_osyx_rofi_blur() {
  local theme="${1:-$(cat "${XDG_STATE_HOME:-$HOME/.local/state}/osyx/current" 2>/dev/null)}"
  local backgrounds_dir="$_OSYX_BACKGROUNDS_DIR"
  local output="$HOME/.cache/osyx/bg-rofi-blur.png"
  local wallpaper=""

  mkdir -p "${output:h}"

  for ext in jpg png webp; do
    local f="$backgrounds_dir/$theme.$ext"
    [[ -f "$f" || -L "$f" ]] && wallpaper="$f" && break
  done

  [[ -z "$wallpaper" ]] && { _osyx_log "rofi-blur: no wallpaper found for $theme"; return 1 }

  magick "$(readlink -f "$wallpaper")" \
    -resize 1366x768^ -gravity center -extent 1366x768 -blur 0x8 \
    "$output"
}
