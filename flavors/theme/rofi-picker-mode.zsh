#!/usr/bin/env zsh
# theme/rofi-picker-mode.zsh

cache_dir="$HOME/.cache/osyx/rofi-thumbs"

if [[ -n "$1" ]]; then
  local theme="$1"
  (
    source "$HOME/dotfiles/flavors/themes.zsh"
    _osyx_apply_theme "$theme"
  ) </dev/null >/dev/null 2>&1 &
  disown
  exit 0
fi

print -r -- $'\x00prompt\x1fSelect Theme'

for theme in $(source "$HOME/dotfiles/flavors/themes.zsh"; _osyx_theme_list); do
  thumb="$cache_dir/$theme.png"
  [[ -f "$thumb" ]] || continue
  print -r -- "${theme}"$'\x00icon\x1f'"${thumb}"
done
