#!/usr/bin/env zsh

_osyx_rofi_blur_cache_dir() {
  print -r -- "$HOME/.cache/osyx/rofi-blur"
}

# Pre-generate blurred backgrounds for all themes (run manually or after adding new wallpapers)
_osyx_rofi_blur_pregenerate() {
  local backgrounds_dir="$_OSYX_BACKGROUNDS_DIR"
  local cache_dir
  cache_dir="$(_osyx_rofi_blur_cache_dir)"
  mkdir -p "$cache_dir"

  local f theme ext
  for f in "$backgrounds_dir"/*.(jpg|png|webp)(N); do
    theme="${f:t:r}"
    local out="$cache_dir/$theme.png"

    # skip if already generated and source hasn't changed
    [[ -f "$out" && "$f" -ot "$out" ]] && continue

    magick "$(readlink -f "$f")" \
      -resize 1366x768^ -gravity center -extent 1366x768 -blur 0x8 \
      "$out" \
      && _osyx_log "rofi-blur: generated for $theme" \
      || _osyx_log "rofi-blur: failed for $theme"
  done
}

# Cheap switch-time step: just point rofi's bg at the cached blur
_osyx_rofi_blur() {
  local theme="${1:-$(cat "${XDG_STATE_HOME:-$HOME/.local/state}/osyx/current" 2>/dev/null)}"
  local cache_dir
  cache_dir="$(_osyx_rofi_blur_cache_dir)"
  local cached="$cache_dir/$theme.png"
  local output="$HOME/.cache/osyx/bg-rofi-blur.png"

  if [[ ! -f "$cached" ]]; then
    _osyx_log "rofi-blur: no cached blur for $theme, generating now"
    _osyx_rofi_blur_pregenerate
  fi

  [[ -f "$cached" ]] || { _osyx_log "rofi-blur: still missing for $theme"; return 1 }

  ln -sf "$cached" "$output"
}
