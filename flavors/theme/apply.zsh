_osyx_generate_theme_files() {
  local theme="$1"

  if [[ ! -f "$_OSYX_GENERATE_SCRIPT" ]]; then
    _osyx_log "generate.py not found, skipping"
    return 0
  fi

  python3 "$_OSYX_GENERATE_SCRIPT" "$theme" >/dev/null 2>&1 \
    || _osyx_log "generate.py failed for $theme"
}

_osyx_write_theme_state() {
  mkdir -p "${_OSYX_STATE_FILE:h}" 2>/dev/null
  print -r -- "$1" >| "$_OSYX_STATE_FILE" 2>/dev/null || true
}

_osyx_wallpaper_file() {
  local theme="$1"
  local ext

  for ext in jpg png webp; do
    if [[ -f "$_OSYX_BACKGROUNDS_DIR/$theme.$ext" ]]; then
      print -r -- "$_OSYX_BACKGROUNDS_DIR/$theme.$ext"
      return 0
    fi
  done

  return 1
}

_osyx_apply_wallpaper() {
  local theme="$1"
  local wallpaper_file

  wallpaper_file="$(_osyx_wallpaper_file "$theme")" || {
    _osyx_log "no wallpaper found for $theme, skipping"
    return 0
  }

  if command -v wallpaper >/dev/null 2>&1; then
    wallpaper set "$wallpaper_file" >/dev/null 2>&1 \
      || _osyx_log "wallpaper set failed for $wallpaper_file"
  elif command -v waypaper >/dev/null 2>&1; then
    waypaper --wallpaper "$wallpaper_file" >/dev/null 2>&1 \
      || _osyx_log "waypaper failed for $wallpaper_file"
  else
    _osyx_log "no wallpaper tool found, skipping"
  fi
}

_osyx_apply_thyx() {
  local theme="$1"

  [[ -d "$_OSYX_THYX_DIR" ]] || return 0

  if [[ -f "$_OSYX_THYX_PRESETS_DIR/$theme.conf" ]]; then
    cp -- "$_OSYX_THYX_PRESETS_DIR/$theme.conf" "$_OSYX_THYX_THEME_CONF"
  else
    cp -- "$_OSYX_THYX_PRESETS_DIR/$_OSYX_THYX_FALLBACK.conf" "$_OSYX_THYX_THEME_CONF"
  fi
}

_osyx_reload_kitty() {
  command -v pgrep >/dev/null 2>&1 || return 0

  local pid
  for pid in ${(f)"$(pgrep -u "$USER" -x kitty 2>/dev/null)"}; do
    kill -USR1 "$pid" 2>/dev/null || true
  done
}

_osyx_reload_hyprland() {
  if command -v hyprctl >/dev/null 2>&1; then
    hyprctl reload >/dev/null 2>&1 || _osyx_log "hyprctl reload failed"
  else
    _osyx_log "hyprctl not found, skipping"
  fi
}

_osyx_reload_sway() {
  if command -v swaymsg >/dev/null 2>&1; then
    swaymsg reload >/dev/null 2>&1 || _osyx_log "sway reload failed"
  else
    _osyx_log "sway not running, skipping"
  fi
}

_osyx_reload_swaync() {
  if pgrep -x swaync >/dev/null 2>&1; then
    pkill -USR2 -x swaync 2>/dev/null || {
      pkill -x swaync 2>/dev/null
      sleep 0.2
      swaync & disown 2>/dev/null
    }
  else
    swaync & disown 2>/dev/null
  fi
}

_osyx_reload_mako() {
  if command -v makoctl >/dev/null 2>&1; then
    makoctl reload >/dev/null 2>&1 || _osyx_log "makoctl reload failed"
  else
    pkill -x mako >/dev/null 2>&1 || true
    (mako >/dev/null 2>&1 & disown) >/dev/null 2>&1 \
      || _osyx_log "mako not found, skipping"
  fi
}

_osyx_reload_btop() {
  if pgrep -x btop >/dev/null 2>&1; then
    pkill -USR1 -x btop 2>/dev/null || {
      _osyx_log "btop reload not supported, restart required"
      notify-send "Btop" "Theme updated. Please restart Btop to apply changes." 2>/dev/null
    }
  else
    _osyx_log "btop not running, skipping"
  fi
}

_osyx_reload_tmux() {
  if command -v tmux >/dev/null 2>&1 && tmux list-sessions >/dev/null 2>&1; then
    tmux source-file "$HOME/.tmux.conf" >/dev/null 2>&1 \
      || _osyx_log "tmux source failed"
  else
    _osyx_log "tmux not running, skipping"
  fi
}

_osyx_reload_nvim() {
  if ! command -v nvim >/dev/null 2>&1; then
    _osyx_log "nvim not found, skipping"
    return 0
  fi

  local sock
  for sock in \
    /run/user/$(id -u)/nvim.*.0 \
    /tmp/nvim.${USER}/**/nvim.*.0(N); do
    [[ -S "$sock" ]] || continue
    nvim --server "$sock" --remote-send '<Cmd>OsyxFlip<CR>' >/dev/null 2>&1 \
      || _osyx_log "nvim socket $sock unreachable, skipping"
  done
}

# _osyx_reload_waybar() {
#   if pgrep -x waybar >/dev/null 2>&1; then
#     pkill -USR2 -x waybar 2>/dev/null || {
#       pkill -x waybar 2>/dev/null
#       waybar & disown 2>/dev/null
#     }
#   else
#     waybar & disown 2>/dev/null
#   fi
# }

_osyx_apply_theme() {
  local theme="$1"

  _osyx_generate_theme_files "$theme"
  _osyx_write_theme_state "$theme"
  _osyx_apply_thyx "$theme"

  _osyx_reload_kitty &!
  _osyx_reload_hyprland &!
  _osyx_reload_sway &!
  # _osyx_reload_swaync &!
  _osyx_reload_mako &!
  _osyx_apply_wallpaper "$theme" &!
  _osyx_rofi_blur "$theme" &!
  _osyx_reload_tmux &!
  _osyx_reload_nvim &!
  _osyx_reload_btop &!
  # _osyx_reload_waybar &!

  _osyx_reload_all
}
