#!/usr/bin/env bash

function run {
  if ! pgrep $1 ;
  then
    $@&
  fi
}

#starting utility applications at boot time
numlockx &
picom &
/nix/store/$(ls -la /nix/store | grep polkit-gnome | grep '^d' | awk '{print $9}')/libexec/polkit-gnome-authentication-agent-1 & 
dunst &
greenclip daemon &
cp ~/.dotfiles/home/configs/qtile/scripts/variety-x11.sh ~/.config/variety/scripts/set_wallpaper &
variety 
