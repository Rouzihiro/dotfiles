_OSYX_THEME_ROOT="${${(%):-%x}:A:h}"

source "$_OSYX_THEME_ROOT/theme/config.zsh"
source "$_OSYX_THEME_ROOT/theme/reload.zsh"
source "$_OSYX_THEME_ROOT/theme/select.zsh"
source "$_OSYX_THEME_ROOT/theme/apply.zsh"
source "$_OSYX_THEME_ROOT/theme/osyx_rofi-blur.zsh"
source "$_OSYX_THEME_ROOT/theme/rofi-picker.zsh"

_osyx_register_autoreload

themes() {
  local choice

  choice="$(_osyx_choose_theme "${1:-}")" || return 1
  _osyx_apply_theme "$choice"
}
