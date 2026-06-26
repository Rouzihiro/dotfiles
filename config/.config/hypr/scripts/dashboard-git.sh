#!/bin/sh

if hyprctl clients | grep -q "class: dashboard-git"; then
    hyprctl dispatch closewindow "class:^(dashboard-git)$"
else
kitty --app-id dashboard-git env NO_STARSHIP=1 zsh -ic \
  'cd ~/dotfiles && git tree; read -r _'
fi
