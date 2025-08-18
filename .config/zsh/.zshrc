export ZSH="$HOME/.oh-my-zsh"
export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH=$HOME/bin:/usr/local/bin:$PATH
for dir in $HOME/.local/bin/*/; do
    export PATH="$PATH:$dir"
done

plugins=( 
    git
    dnf
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

[[ -f ~/.profile ]] && . ~/.profile
[ -f ~/.aliases ] && source ~/.aliases
[ -f ~/.aliases-functions ] && source ~/.aliases-functions
[ -f ~/.aliases-functions2 ] && source ~/.aliases-functions2
[ -f ~/.aliases-arch ] && source ~/.aliases-arch
#[ -f ~/.aliases-fedora ] && source ~/.aliases-fedora

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
