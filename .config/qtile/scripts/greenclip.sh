#!/usr/bin/env bash

rofi -modi "clipboard:greenclip print" -show clipboard -replace -config ~/.dotfiles/home/configs/rofi/config-cliphist.rasi -run-command '{cmd}'
