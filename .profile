export GTK_THEME="Kanagawa-Dark"
export GTK2_RC_FILES="$HOME/.themes/Kanagawa-Dark/gtk-2.0/gtkrc"
export GTK_THEME=Kanagawa-Dark

[ "$(tty)" = "/dev/tty1" ] && exec sway
