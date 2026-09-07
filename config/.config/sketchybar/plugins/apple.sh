#!/usr/bin/env bash

CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}"
source "$CONFIG_DIR/colors.sh"

sketchybar --set apple.logo popup.drawing=toggle

if [ "$(sketchybar --query apple.logo | jq -r '.popup.drawing')" = "on" ]; then
    sketchybar --add item apple.prefs popup.apple.logo \
               --set apple.prefs icon="󰒓" \
                                icon.color=$ACCENT \
                                label="System Preferences" \
                                click_script="open /System/Applications/System\ Preferences.app; sketchybar --set apple.logo popup.drawing=off"

    sketchybar --add item apple.activity popup.apple.logo \
               --set apple.activity icon="󰖚" \
                                   icon.color=$SUCCESS \
                                   label="Activity Monitor" \
                                   click_script="open /System/Applications/Utilities/Activity\ Monitor.app; sketchybar --set apple.logo popup.drawing=off"

    sketchybar --add item apple.lock popup.apple.logo \
               --set apple.lock icon="󰌾" \
                               icon.color=$ERROR \
                               label="Lock Screen" \
                               click_script="pmset displaysleepnow; sketchybar --set apple.logo popup.drawing=off"

    sketchybar --add item apple.sleep popup.apple.logo \
               --set apple.sleep icon="󰤄" \
                                icon.color=$WARNING \
                                label="Sleep" \
                                click_script="pmset sleepnow; sketchybar --set apple.logo popup.drawing=off"
else
    sketchybar --remove apple.prefs apple.activity apple.lock apple.sleep
fi
