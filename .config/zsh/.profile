export LANG=en_US.UTF-8
export BROWSER=librewolf
export EDITOR="nvim"
export SUDO_EDITOR="$EDITOR"
export VISUAL="$EDITOR"
export BAT_THEME=ansi
export GTK_THEME="Kanagawa-Dark"
export GTK2_RC_FILES="$HOME/.themes/Kanagawa-Dark/gtk-2.0/gtkrc"
export GTK_THEME=Kanagawa-Dark

[ "$(tty)" = "/dev/tty1" ] && exec sway
