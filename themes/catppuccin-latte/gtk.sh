#!/bin/bash
sleep 2  # Wait for D-Bus to be ready

gsettings set org.gnome.desktop.interface gtk-theme 'Catppuccin-Latte'
gsettings set org.gnome.desktop.interface icon-theme 'Tela-light'
gsettings set org.gnome.desktop.interface cursor-theme 'la-capitaine-cursor-theme'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
gsettings set org.gnome.desktop.interface cursor-size 24

export XCURSOR_THEME=la-capitaine-cursor-theme
