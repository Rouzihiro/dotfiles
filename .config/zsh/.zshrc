export ZSH="$HOME/.oh-my-zsh"
[ -f "$ZSH/oh-my-zsh.sh" ] && source "$ZSH/oh-my-zsh.sh"

export HISTFILE="$XDG_CACHE_HOME/zsh/.zsh_history"
mkdir -p "$(dirname "$HISTFILE")"

export HISTORY_IGNORE="(ls|ls -a|cd|clear|pwd|exit|cd -|cd ..)"
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt appendhistory

export PATH="$HOME/.local/share/bob/nvim-bin:$HOME/.local/bin:$HOME/bin:/usr/local/bin:$PATH"
for dir in "$HOME/.local/bin/"*/; do
    [ -d "$dir" ] && export PATH="$PATH:$dir"
done

plugins=(
    git
    dnf
    zsh-autosuggestions
    # zsh-syntax-highlighting will be sourced manually last
)

for file in .profile .aliases .aliases-functions .aliases-functions2 .aliases-arch; do
    [ -f "$ZDOTDIR/$file" ] && source "$ZDOTDIR/$file"
done
# [ -f "$ZDOTDIR/.aliases-fedora" ] && source "$ZDOTDIR/.aliases-fedora"

if command -v fzf >/dev/null 2>&1; then
    source <(fzf --zsh)
fi

ENABLE_CORRECTION="true"

# -------------------------------
# SSH Agent Management
# -------------------------------
if [ -z "$SSH_AUTH_SOCK" ]; then
    export SSH_AUTH_SOCK=$(find /tmp -type s -name "agent.*" 2>/dev/null | head -n 1)
    if [ -z "$SSH_AUTH_SOCK" ]; then
        eval "$(ssh-agent -s)" >/dev/null
    fi
    ssh-add -l >/dev/null 2>&1 || ssh-add ~/.ssh/HP-Nixo
fi

# -------------------------------
# Starship prompt
# -------------------------------
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
fi

# -------------------------------
# Syntax highlighting (must be last)
# -------------------------------
if [ -f "${ZSH_CUSTOM:-$ZSH/custom}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
    source "${ZSH_CUSTOM:-$ZSH/custom}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

