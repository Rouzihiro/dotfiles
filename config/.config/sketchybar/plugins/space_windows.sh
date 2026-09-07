#!/usr/bin/env bash

CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}"
source "$CONFIG_DIR/colors.sh"

FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused)

update_all_workspaces() {
    WORKSPACE_COUNT=9
    for i in $(seq 1 $WORKSPACE_COUNT); do
        if [ "$i" = "$FOCUSED_WORKSPACE" ]; then
            sketchybar --set space.$i \
                icon.highlight=true \
                background.border_color=$PILL_BORDER_ACTIVE
        else
            sketchybar --set space.$i \
                icon.highlight=false \
                background.border_color=$PILL_BORDER
        fi
    done
}

if [ "$SENDER" = "space_change" ] || \
   [ "$SENDER" = "window_change" ] || \
   [ "$SENDER" = "aerospace_workspace_change" ] || \
   [ "$SENDER" = "aerospace_focus_change" ]; then
    update_all_workspaces
fi
