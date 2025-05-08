# Only launch Hyprland on TTY1 (or any specific TTY)
if [[ -z $DISPLAY && $(tty) = /dev/tty1 ]]; then
    exec Hyprland
fi

# Source .zshrc for interactive shell setups like aliases and functions
if [ -f ~/.zshrc ]; then
    source ~/.zshrc
fi

