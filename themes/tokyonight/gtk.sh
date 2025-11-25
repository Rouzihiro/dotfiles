#!/bin/bash
sleep 2  # Wait for D-Bus to be ready

gsettings set org.gnome.desktop.interface gtk-theme 'Tokyo-Night'
gsettings set org.gnome.desktop.interface icon-theme 'Tela-dark'
gsettings set org.gnome.desktop.interface cursor-theme 'la-capitaine-cursor-theme'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface cursor-size 24

export GTK_THEME=Tokyo-Night
export XCURSOR_THEME=la-capitaine-cursor-theme
