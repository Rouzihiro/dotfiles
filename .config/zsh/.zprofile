if [[ -z $DISPLAY ]] && [[ $(tty) == /dev/tty1 ]]; then
    exec niri
fi

# Source .zshrc for interactive shell setups like aliases and functions
if [ -f ~/.zshrc ]; then
    source ~/.zshrc
fi

