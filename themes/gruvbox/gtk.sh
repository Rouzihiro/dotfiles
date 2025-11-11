#!/bin/bash
sleep 2  # Wait for D-Bus to be ready

gsettings set org.gnome.desktop.interface gtk-theme 'Gruvbox-Dark'
gsettings set org.gnome.desktop.interface icon-theme 'Yaru-blue'
gsettings set org.gnome.desktop.interface cursor-theme 'Adwaita'
gsettings set org.gnome.desktop.interface font-name 'DejaVu Sans Mono 10'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

export GTK_THEME=Gruvbox-Dark
export XCURSOR_THEME=Adwaita
