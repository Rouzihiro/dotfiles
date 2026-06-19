TRAPUSR1() {
  [[ -o zle ]] && zle -I
  clear
  [[ -o zle ]] && zle reset-prompt 2>/dev/null || true
}

_osyx_autoreload() {
  [[ -f "$_OSYX_RELOAD_FILE" ]] || return 0

  local stamp
  stamp=$(<"$_OSYX_RELOAD_FILE")
  [[ "$stamp" == "${_OSYX_LAST_RELOAD:-}" ]] && return 0

  _OSYX_LAST_RELOAD="$stamp"
  clear
  [[ -o zle ]] && zle reset-prompt 2>/dev/null || true
}

_osyx_register_autoreload() {
  [[ -n "${precmd_functions[(re)_osyx_autoreload]}" ]] && return 0
  precmd_functions+=(_osyx_autoreload)
}

_osyx_signal_theme_pid() {
  local pid="$1"

  [[ "$pid" == <-> ]] || return 0
  [[ "$pid" == "$$" ]] && return 0

  kill -0 "$pid" 2>/dev/null || return 0
  kill -USR1 "$pid" 2>/dev/null || true
}

_osyx_signal_idle_zsh() {
  command -v ps >/dev/null 2>&1 || return 0

  ps -u "$USER" -o pid= -o pgid= -o tpgid= -o tty= -o comm= 2>/dev/null \
    | while read -r pid pgid tpgid tty comm; do
        [[ "$tty" != "?" ]] || continue
        [[ "$pgid" == "$tpgid" ]] || continue
        [[ "$comm" == "zsh" || "$comm" == "-zsh" ]] || continue
        _osyx_signal_theme_pid "$pid"
      done
}

_osyx_reload_all() {
  mkdir -p "${_OSYX_RELOAD_FILE:h}"
  print -r -- "$(date +%s%N)" >| "$_OSYX_RELOAD_FILE"

  _osyx_signal_idle_zsh
}
