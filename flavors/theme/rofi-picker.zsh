#!/usr/bin/env zsh
# theme/rofi-picker.zsh

_osyx_rofi_thumb_cache_dir() {
  print -r -- "$HOME/.cache/osyx/rofi-thumbs"
}

_osyx_rofi_thumb_pregenerate() {
  local backgrounds_dir="$_OSYX_BACKGROUNDS_DIR"
  local cache_dir
  cache_dir="$(_osyx_rofi_thumb_cache_dir)"
  mkdir -p "$cache_dir"

  local f theme out
  for f in "$backgrounds_dir"/*.(jpg|png|webp)(N); do
    theme="${f:t:r}"
    out="$cache_dir/$theme.png"

    [[ -f "$out" && "$f" -ot "$out" ]] && continue

    magick "$(readlink -f "$f")" \
      -resize 256x256^ -gravity center -extent 256x256 \
      "$out" \
      && _osyx_log "rofi-thumb: generated for $theme" \
      || _osyx_log "rofi-thumb: failed for $theme"
  done
}

_osyx_rofi_theme_picker() {
  _osyx_rofi_thumb_pregenerate

  rofi -show theme \
    -modi "theme:$_OSYX_THEME_ROOT/theme/rofi-picker-mode.zsh" \
    -theme ~/.config/rofi/grid.rasi \
    -theme-str 'element-icon { size: 6em; }'
}
