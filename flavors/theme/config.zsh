_OSYX_RELOAD_FILE="${_OSYX_RELOAD_FILE:-$HOME/.cache/zsh-reload-trigger}"
_OSYX_LOG_FILE="${_OSYX_LOG_FILE:-$HOME/.cache/osyx.log}"
_OSYX_PALETTES_DIR="${_OSYX_PALETTES_DIR:-$HOME/flavors/palettes}"
_OSYX_BACKGROUNDS_DIR="${_OSYX_BACKGROUNDS_DIR:-$HOME/flavors/backgrounds}"
_OSYX_GENERATE_SCRIPT="${_OSYX_GENERATE_SCRIPT:-$HOME/flavors/generate.py}"
_OSYX_THYX_MAP="${_OSYX_THYX_MAP:-$HOME/flavors/thyx-map.conf}"
_OSYX_STATE_FILE="${_OSYX_STATE_FILE:-$HOME/.cache/theme.current}"
_OSYX_THYX_META="${_OSYX_THYX_META:-/usr/share/sddm/themes/thyx/metadata.desktop}"
_OSYX_THYX_DIR="${_OSYX_THYX_DIR:-/usr/share/sddm/themes/thyx}"

_osyx_log() {
  mkdir -p "${_OSYX_LOG_FILE:h}"
  print -r -- "[$(date '+%H:%M:%S')] $*" >> "$_OSYX_LOG_FILE"
}

_osyx_apply_dircolors() {
  local context="${1:-shell}"

  eval "$(dircolors "$HOME/.dircolors" 2>/dev/null)" \
    || _osyx_log "dircolors not available in $context, skipping"
}
