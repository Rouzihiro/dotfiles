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

_osyx_reload_tmux() {
  if command -v tmux >/dev/null 2>&1 && tmux list-sessions >/dev/null 2>&1; then
    tmux source-file "$HOME/.tmux.conf" >/dev/null 2>&1 \
      || _osyx_log "tmux source failed"
  else
    _osyx_log "tmux not running, skipping"
  fi
}

_osyx_reload_hyprland() {
  if command -v hyprctl >/dev/null 2>&1; then
    hyprctl reload >/dev/null 2>&1 || _osyx_log "hyprctl reload failed"
  else
    _osyx_log "hyprctl not found, skipping"
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

_osyx_thyx_preset() {
  local theme="$1"

  if [[ ! -f "$_OSYX_THYX_MAP" ]]; then
    _osyx_log "thyx-map.conf not found, falling back to ash"
    print -r -- "ash"
    return 0
  fi

  grep -E "^${theme}=" "$_OSYX_THYX_MAP" 2>/dev/null | cut -d= -f2
}

_osyx_update_thyx() {
  local theme="$1"

  if [[ ! -d "$_OSYX_THYX_DIR" || ! -f "$_OSYX_THYX_META" ]]; then
    _osyx_log "thyx not installed, skipping sddm preset update"
    return 0
  fi

  local preset line
  preset="$(_osyx_thyx_preset "$theme")"
  preset="${preset:-ash}"
  line="ConfigFile=themes/$preset.conf"

  if [[ -w "$_OSYX_THYX_META" ]]; then
    _osyx_write_thyx_meta "$_OSYX_THYX_META" "$line"
  elif command -v sudo >/dev/null 2>&1 && sudo test -w "$_OSYX_THYX_META" 2>/dev/null; then
    _osyx_write_thyx_meta_sudo "$_OSYX_THYX_META" "$line"
  else
    _osyx_log "thyx meta not writable, skipping sddm update"
  fi
}

_osyx_write_thyx_meta() {
  local meta="$1"
  local line="$2"

  if grep -q '^ConfigFile=' "$meta" 2>/dev/null; then
    sed -i "s|^ConfigFile=.*$|$line|" "$meta"
  else
    printf '\n%s\n' "$line" >> "$meta"
  fi
}

_osyx_write_thyx_meta_sudo() {
  local meta="$1"
  local line="$2"

  if sudo grep -q '^ConfigFile=' "$meta" 2>/dev/null; then
    sudo sed -i "s|^ConfigFile=.*$|$line|" "$meta"
  else
    printf '%s\n' "$line" | sudo tee -a "$meta" >/dev/null
  fi
}

_osyx_reload_waybar() {
    if pgrep -x waybar >/dev/null 2>&1; then
        # Send SIGUSR2 to waybar to reload config
        pkill -USR2 -x waybar 2>/dev/null || {
            # Fallback: restart waybar
            pkill -x waybar 2>/dev/null
            waybar & disown 2>/dev/null
        }
        _osyx_log "waybar reloaded"
    else
        # Start waybar if not running
        waybar & disown 2>/dev/null
        _osyx_log "waybar started"
    fi
}

_osyx_reload_sway() {
    if command -v swaymsg >/dev/null 2>&1; then
        # Reload sway config
        swaymsg reload >/dev/null 2>&1 || {
            _osyx_log "sway reload failed"
            # Try to reload with full config
            swaymsg -t get_tree >/dev/null 2>&1 && {
                swaymsg reload
            }
        }
        _osyx_log "sway reloaded"
    else
        _osyx_log "sway not running, skipping"
    fi
}

_osyx_reload_swaync() {
    if pgrep -x swaync >/dev/null 2>&1; then
        # Send SIGUSR2 to swaync to reload config
        pkill -USR2 -x swaync 2>/dev/null || {
            # Fallback: restart swaync
            pkill -x swaync 2>/dev/null
            sleep 0.2
            swaync & disown 2>/dev/null
        }
    else
        # Start swaync if not running
        swaync & disown 2>/dev/null
    fi
}

_osyx_reload_btop() {
    # Btop reads config on startup
    # We can send SIGUSR1 to reload the theme
    if pgrep -x btop >/dev/null 2>&1; then
        pkill -USR1 -x btop 2>/dev/null || {
            _osyx_log "btop reload not supported, restart required"
            # Option: notify user
            notify-send "Btop" "Theme updated. Please restart Btop to apply changes." 2>/dev/null
        }
        _osyx_log "btop notified"
    else
        _osyx_log "btop not running, skipping"
    fi
}

_osyx_apply_theme() {
  local theme="$1"

  _osyx_generate_theme_files "$theme"
  _osyx_write_theme_state "$theme"

  _osyx_reload_hyprland &!
 	_osyx_reload_sway &! 
 	_osyx_reload_swaync &! 
  _osyx_reload_mako &!
  _osyx_apply_wallpaper "$theme" &!

  _osyx_reload_tmux &!
  _osyx_reload_nvim &!
  # _osyx_reload_waybar &!
	_osyx_reload_btop &!
  _osyx_reload_all >/dev/null 2>&1 &!
  _osyx_update_thyx "$theme" &!
}
