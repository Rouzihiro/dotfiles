#!/bin/sh
source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"

sketchybar --add event aerospace_workspace_change

get_space_icon() {
    case $1 in
        1) echo "$SPACE_1" ;;
        2) echo "$SPACE_2" ;;
        3) echo "$SPACE_3" ;;
        4) echo "$SPACE_4" ;;
        5) echo "$SPACE_5" ;;
        *) echo "" ;;
    esac
}

for sid in 1 2 3 4 5; do
    SPACE_ICON=$(get_space_icon $sid)

    sketchybar --add item space.$sid left \
        --subscribe space.$sid aerospace_workspace_change \
        --set space.$sid \
        icon="$sid" \
        icon.font="SF Pro:Bold:11.0" \
        icon.color=$WS_INACTIVE_FG \
        icon.padding_left=6 \
        icon.padding_right=2 \
        icon.drawing=on \
        label="$SPACE_ICON" \
        label.font="sketchybar-app-font:Regular:16.0" \
        label.color=$WS_INACTIVE_FG \
        label.padding_left=2 \
        label.padding_right=6 \
        label.drawing=on \
        drawing=on \
        padding_left=2 \
        padding_right=2 \
        background.drawing=off \
        click_script="aerospace workspace $sid" \
        script="$PLUGIN_DIR/aerospace.sh $sid"
done

# Initial focused workspace
sketchybar --set space.1 \
    icon.color=$WS_ACTIVE_FG \
    label.color=$WS_ACTIVE_FG

# Pill grouping apple logo + spaces
sketchybar --add bracket spaces_bracket apple.logo space.1 space.2 space.3 space.4 space.5 \
           --set spaces_bracket \
           background.color=$PILL_BG \
           background.border_color=$PILL_BORDER \
           background.border_width=1 \
           background.corner_radius=14 \
           background.height=28 \
           background.drawing=on
