#!/bin/sh

if swaymsg -t get_tree | grep -q '"app_id": "dashboard-git"'; then
    swaymsg '[app_id="^dashboard-git$"] kill'
else
kitty --app-id dashboard-git env NO_STARSHIP=1 zsh -ic \
  'cd ~/dotfiles && git tree; read -r _'
fi