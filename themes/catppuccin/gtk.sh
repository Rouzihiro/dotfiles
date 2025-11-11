#!/bin/bash
sleep 2  # Wait for D-Bus to be ready

gsettings set org.gnome.desktop.interface gtk-theme 'Catppuccin-Dark'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface icon-theme 'Yaru-blue'
gsettings set org.gnome.desktop.interface cursor-theme 'Adwaita'
gsettings set org.gnome.desktop.interface font-name 'DejaVu Sans Mono 10'

export GTK_THEME=Catppuccin-Dark
export XCURSOR_THEME=Adwaita
