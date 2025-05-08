export PATH=$HOME/bin:/usr/local/bin:$PATH
export ZSH="$HOME/.oh-my-zsh"

plugins=( 
    git
    dnf
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Start dbus if not running
if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    eval $
fi

#fastfetch -c $HOME/.config/fastfetch/config-compact.jsonc

# Set-up FZF key bindings (CTRL R for fuzzy history finder)
source <(fzf --zsh)

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# SSH Agent Management
if [ -z "$SSH_AUTH_SOCK" ]; then
    # Try all possible socket locations
    export SSH_AUTH_SOCK=$(find /tmp -type s -name "agent.*" 2>/dev/null | head -n 1)
    # Fallback: Start new agent if none found
    if [ -z "$SSH_AUTH_SOCK" ]; then
        eval "$(ssh-agent -s)" >/dev/null
    fi
    # Add key if not already loaded
    ssh-add -l >/dev/null || ssh-add ~/.ssh/HP-Nixo
fi

eval "$(starship init zsh)"
