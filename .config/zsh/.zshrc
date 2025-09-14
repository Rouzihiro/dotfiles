# -------------------------------
# Oh-My-Zsh Setup
# -------------------------------
export ZSH="$HOME/.oh-my-zsh"

plugins=(
    git
    dnf
    zsh-autosuggestions
    zsh-syntax-highlighting
)

[ -f "$ZSH/oh-my-zsh.sh" ] && source "$ZSH/oh-my-zsh.sh"

# -------------------------------
# History Settings
# -------------------------------
export HISTFILE="$XDG_CACHE_HOME/zsh/.zsh_history"
mkdir -p "$(dirname "$HISTFILE")"

export HISTORY_IGNORE="(ls|ls -a|cd|clear|pwd|exit|cd -|cd ..)"
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt INC_APPEND_HISTORY 
setopt SHARE_HISTORY
setopt autocd              # change directory just by typing its name
setopt auto_pushd          # push old dir onto stack when changing dirs
setopt pushd_ignore_dups   # no duplicate entries in directory stack
setopt correctall 
setopt interactivecomments # allow # comments in interactive shell
setopt magicequalsubst     # expand filenames in foo=*.txt style arguments
setopt extended_glob       # advanced globbing (regex-like patterns)
setopt nonomatch           # don’t throw error if glob matches nothing
setopt no_clobber          # prevent overwriting files with > (use >! to force)
setopt notify              # report status of background jobs immediately
setopt numericglobsort     # natural numeric sort order (file1 file2 file10)
setopt promptsubst         # allow variables/commands in your prompt

# -------------------------------
# PATH Setup (prioritize ~/.local/bin)
# -------------------------------
eval "$(dircolors -b $HOME/.config/zsh/.dircolors-nightfox)"
export PATH="$HOME/.local/bin:$HOME/.local/share/bob/nvim-bin:/usr/local/bin:$PATH:$HOME/.dotnet/tools"

# Add subfolders inside ~/.local/bin (priority preserved)
for dir in "$HOME/.local/bin/"*/; do
    [ -d "$dir" ] && export PATH="$dir:$PATH"
done

# -------------------------------
# Load aliases
# -------------------------------
for file in "$ZDOTDIR"/.aliases*; do
    [ -f "$file" ] && source "$file"
done

# -------------------------------
# FZF key bindings
# -------------------------------
if command -v fzf >/dev/null 2>&1; then
    source <(fzf --zsh)
    bindkey -r '^[c'         # remove Alt+c
    bindkey '^G' fzf-cd-widget # new binding: Ctrl+g
    # fzf default keybindings:
    # Ctrl+t → fzf-file-widget   (insert selected files)
    # Ctrl+r → fzf-history-widget (search command history)
    # Alt+c  → fzf-cd-widget     (cd into selected dir)  [DISABLED]
	fi

# ─────────────────────────────
# Autostart sway on tty1
# ─────────────────────────────
# [ "$(tty)" = "/dev/tty1" ] && exec sway


# ─────────────────────────────
# SSH Agent Setup (only once per login)
# ─────────────────────────────

# Path to ssh-agent socket
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

# Start ssh-agent if not running
if ! pgrep -u "$USER" ssh-agent >/dev/null 2>&1; then
    eval "$(ssh-agent -a "$SSH_AUTH_SOCK")" >/dev/null
fi

# Add keys only if none are loaded
if ! ssh-add -l >/dev/null 2>&1; then
    ssh-add ~/.ssh/id_github 2>/dev/null
    ssh-add ~/.ssh/id_ftp 2>/dev/null
    ssh-add ~/.ssh/id_openweather 2>/dev/null
fi

# -------------------------------
# Starship prompt
# -------------------------------
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
fi


