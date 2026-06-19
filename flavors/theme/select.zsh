_osyx_theme_list() {
  local f basename

  [[ -d "$_OSYX_PALETTES_DIR" ]] || return 1

  for f in "$_OSYX_PALETTES_DIR"/*.toml(N); do
    basename="${f##*/}"
    print -r -- "${basename%%.toml}"
  done
}

_osyx_current_theme() {
  [[ -f "$_OSYX_STATE_FILE" ]] || return 1

  local current
  current=$(<"$_OSYX_STATE_FILE")
  [[ -n "$current" ]] || return 1

  print -r -- "$current"
}

_osyx_next_theme() {
  local current="$1"
  shift

  local -a themes=("$@")
  local i count=${#themes[@]}

  for (( i = 1; i <= count; i++ )); do
    if [[ "${themes[i]}" == "$current" ]]; then
      print -r -- "${themes[$(( i % count + 1 ))]}"
      return 0
    fi
  done

  print -r -- "${themes[1]}"
}

_osyx_choose_theme() {
  local mode="$1"
  local -a themes=("${(@f)$(_osyx_theme_list)}")

  if (( ${#themes[@]} == 0 )); then
    print -ru2 -- "no palettes found in $_OSYX_PALETTES_DIR"
    return 1
  fi

  if [[ "$mode" == "rotate" ]]; then
    _osyx_next_theme "$(_osyx_current_theme 2>/dev/null)" "${themes[@]}"
    return $?
  fi

  if [[ -n "$mode" ]]; then
    if [[ -f "$_OSYX_PALETTES_DIR/$mode.toml" ]]; then
      print -r -- "$mode"
      return 0
    fi
    print -ru2 -- "theme not found: $mode"
    return 1
  fi

  if ! command -v fzf >/dev/null 2>&1; then
    print -ru2 -- "fzf not found."
    return 1
  fi

  printf '%s\n' "${themes[@]}" | fzf --prompt='theme > ' --height=40%
}
