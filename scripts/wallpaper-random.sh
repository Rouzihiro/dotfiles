#!/bin/sh

ls ~/dotfiles/user/wallpapers | sort -R | tail -1 | while read file; do
    swww img ~~/dotfiles/user/wallpapers/$file --transition-type center --transition-fps 60;
done
