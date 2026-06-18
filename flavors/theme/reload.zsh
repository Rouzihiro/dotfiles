TRAPUSR1() {
  [[ -o zle ]] && zle -I
  _osyx_apply_dircolors "TRAPUSR1"
  clear
  [[ -o zle ]] && zle reset-prompt 2>/dev/null || true
}

_osyx_autoreload() {
  [[ -f "$_OSYX_RELOAD_FILE" ]] || return 0

  local stamp
  stamp=$(<"$_OSYX_RELOAD_FILE")
  [[ "$stamp" == "${_OSYX_LAST_RELOAD:-}" ]] && return 0

  _OSYX_LAST_RELOAD="$stamp"
  _osyx_apply_dircolors "autoreload"
  clear
  [[ -o zle ]] && zle reset-prompt 2>/dev/null || true
}

_osyx_register_autoreload() {
  [[ -n "${precmd_functions[(re)_osyx_autoreload]}" ]] && return 0
  precmd_functions+=(_osyx_autoreload)
}

_osyx_reload_all() {
  mkdir -p "${_OSYX_RELOAD_FILE:h}"
  print -r -- "$(date +%s%N)" >| "$_OSYX_RELOAD_FILE"
}