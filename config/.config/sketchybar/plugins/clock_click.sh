#!/usr/bin/env bash

CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}"
source "$CONFIG_DIR/colors.sh"

sketchybar --set clock popup.drawing=toggle

if [ "$(sketchybar --query clock | jq -r '.popup.drawing')" = "on" ]; then
    FULL_DATE=$(date "+%A, %B %d, %Y")
    WEEK_NUMBER=$(date "+Week %V")
    DAY_OF_YEAR=$(date "+Day %j of %Y")

    sketchybar --add item clock.full_date popup.clock \
               --set clock.full_date icon="󰸘" \
                                   icon.color=$WARNING \
                                   label="$FULL_DATE" \
                                   click_script="open /System/Applications/Calendar.app; sketchybar --set clock popup.drawing=off"

    sketchybar --add item clock.week popup.clock \
               --set clock.week icon="󰸗" \
                              icon.color=$ACCENT \
                              label="$WEEK_NUMBER" \
                              click_script="sketchybar --set clock popup.drawing=off"

    sketchybar --add item clock.day_of_year popup.clock \
               --set clock.day_of_year icon="󰸙" \
                                     icon.color=$SUCCESS \
                                     label="$DAY_OF_YEAR" \
                                     click_script="sketchybar --set clock popup.drawing=off"

    sketchybar --add item clock.calendar popup.clock \
               --set clock.calendar icon="󰸝" \
                                  icon.color=$WARNING \
                                  label="Open Calendar" \
                                  click_script="open /System/Applications/Calendar.app; sketchybar --set clock popup.drawing=off"
else
    sketchybar --remove clock.full_date clock.week clock.day_of_year clock.calendar
fi
