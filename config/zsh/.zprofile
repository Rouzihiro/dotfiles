# Load login environment

[ -f "$HOME/.profile" ] && source "$HOME/.profile"

wm-select() {
    local choice
    local log_dir="$HOME/.logs"

    mkdir -p "$log_dir"

    choice=$(printf "%s\n" \
        " Qtile" \
        " Sway" \
        " Hyprland" \
        " Shell" |
        fzf --prompt="Session ❯ " \
            --height=~40% \
            --layout=reverse \
            --border \
            --margin=1 \
            --pointer="➜") || return

    case "$choice" in
        " Qtile")
            : > "$log_dir/qtile.log"
            exec dbus-run-session qtile start -b wayland \
                > "$log_dir/qtile.log" 2>&1
            ;;

        " Sway")
            : > "$log_dir/sway.log"
            exec sway \
                > "$log_dir/sway.log" 2>&1
            ;;

        " Hyprland")
            : > "$log_dir/hyprland.log"
            exec Hyprland \
                > "$log_dir/hyprland.log" 2>&1
            ;;

        " Shell")
            return
            ;;
    esac
}


if [ "$(tty)" = "/dev/tty1" ] && [ -z "$WAYLAND_DISPLAY" ]; then
    wm-select
fi
