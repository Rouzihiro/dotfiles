#!/usr/bin/env bash

# Monitor switcher for:
# - Sway
# - Hyprland
# - Qtile Wayland


# Detect compositor

if hyprctl monitors >/dev/null 2>&1; then

    COMPOSITOR="hyprland"

elif swaymsg -t get_outputs >/dev/null 2>&1; then

    COMPOSITOR="sway"

elif qtile cmd-obj -o cmd -f status >/dev/null 2>&1; then

    COMPOSITOR="qtile"

else
    echo "No supported Wayland compositor detected" >&2
    exit 1
fi



CHOICE=$(printf \
"HDMI Only\nLaptop Only\nBoth Displays" \
| fzf \
    --prompt="Monitor > " \
    --height=40% \
    --layout=reverse \
    --border)


[ -z "$CHOICE" ] && exit 0



apply_sway() {

    case "$CHOICE" in

        "HDMI Only")

            swaymsg output eDP-1 disable
            swaymsg output HDMI-A-1 enable \
                mode 1920x1080@60Hz

            ;;


        "Laptop Only")

            swaymsg output HDMI-A-1 disable
            swaymsg output eDP-1 enable \
                mode 1920x1080@120Hz

            ;;


        "Both Displays")

            swaymsg output eDP-1 enable \
                mode 1920x1080@120Hz

            swaymsg output HDMI-A-1 enable \
                mode 1920x1080@60Hz \
                position 1920,0

            ;;

    esac

}



apply_hyprland() {

    case "$CHOICE" in

        "HDMI Only")

            hyprctl keyword monitor \
                "eDP-1,disable"

            hyprctl keyword monitor \
                "HDMI-A-1,1920x1080@60,0x0,1"

            ;;


        "Laptop Only")

            hyprctl keyword monitor \
                "HDMI-A-1,disable"

            hyprctl keyword monitor \
                "eDP-1,1920x1080@120,0x0,1"

            ;;


        "Both Displays")

            hyprctl keyword monitor \
                "eDP-1,1920x1080@120,0x0,1"

            hyprctl keyword monitor \
                "HDMI-A-1,1920x1080@60,1920x0,1"

            ;;

    esac

}



apply_qtile() {

    case "$CHOICE" in


        "HDMI Only")

            wlr-randr \
                --output eDP-1 \
                --off

            wlr-randr \
                --output HDMI-A-1 \
                --on \
                --mode 1920x1080@60.000000 \
                --pos 0,0

            ;;


        "Laptop Only")

            wlr-randr \
                --output HDMI-A-1 \
                --off

            sleep 1

            wlr-randr \
                --output eDP-1 \
                --on \
                --mode 1920x1080@120.018997 \
                --pos 0,0

            ;;


        "Both Displays")

            wlr-randr \
                --output eDP-1 \
                --on \
                --mode 1920x1080@120.018997 \
                --pos 0,0

            sleep 1

            wlr-randr \
                --output HDMI-A-1 \
                --on \
                --mode 1920x1080@60.000000 \
                --pos 1920,0

            ;;

    esac

    # Give wlroots a moment to settle after the output change, then tell
    # Qtile to recompute its screen list. wlr-randr has no idea Qtile
    # exists, so without this Qtile keeps whatever screen/group mapping it
    # had before the switch — which is why groups get "stuck" pointing at
    # a screen that no longer exists, and rofi can land on a dead monitor.
    sleep 0.5
    qtile cmd-obj -o cmd -f reconfigure_screens

}



case "$COMPOSITOR" in

    sway)
        apply_sway
        ;;

    hyprland)
        apply_hyprland
        ;;

    qtile)
        apply_qtile
        ;;

esac
