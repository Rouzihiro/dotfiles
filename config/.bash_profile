# ~/.bash_profile
# ─────────────────────────────

# XDG cache fallback
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

# zsh cache
export ZSH_CACHE_DIR="$XDG_CACHE_HOME/zsh"


# Broot launcher
if [ -f ~/.config/broot/launcher/bash/br ]; then
    source ~/.config/broot/launcher/bash/br
fi
