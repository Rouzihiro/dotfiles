# -------------------------------
# Modernized Bash RC (Zsh-like behavior)
# -------------------------------

# -------------------------------
# Locale
# -------------------------------
export LANG=en_US.UTF-8

# -------------------------------
# PATH Setup (prioritize ~/.local/bin)
# -------------------------------
export PATH="$HOME/.local/bin:$HOME/.local/share/bob/nvim-bin:$HOME/.local/share/bob/nightly/bin:/usr/local/bin:$HOME/bin:$PATH:$HOME/.dotnet/tools"

for dir in "$HOME/.local/bin/"*/ "$HOME/bin/"*/; do
    [ -d "$dir" ] && PATH="$dir:$PATH"
done
export PATH

# -------------------------------
# Source global definitions
# -------------------------------
[ -f /etc/bashrc ] && source /etc/bashrc
[[ -f ~/.profile ]] && source ~/.profile

# -------------------------------
# Load aliases and functions
# -------------------------------
ZSH_CONFIG="$HOME/.config/zsh"

for file in "$ZSH_CONFIG"/.aliases*; do
    [ -f "$file" ] || continue          
    [[ "$(basename "$file")" == ".aliases-arch" ]] && continue  # skip this one
    source "$file"
done

# Optional Bash-specific scripts
if [ -d "$HOME/.config/zsh/.bashrc.d" ]; then
    for rc in "$HOME/.config/zsh/.bashrc.d"/*; do
        [ -f "$rc" ] && source "$rc"
    done
fi
unset rc

# -------------------------------
# Dircolors (Nightfox theme)
# -------------------------------
if [ -f "$ZSH_CONFIG/.dircolors" ]; then
    eval "$(dircolors -b "$ZSH_CONFIG/.dircolors")"
fi


# -------------------------------
# FZF Key Bindings (Bash)
# -------------------------------
if command -v fzf >/dev/null 2>&1; then
    # Load bash completion for fzf
    [ -f /usr/share/fzf/key-bindings.bash ] && source /usr/share/fzf/key-bindings.bash
    # Or dynamically:
    # source <(fzf --completion bash)

    # Ctrl+g → fzf-cd-widget (Bash style)
    if type fzf-cd-widget >/dev/null 2>&1; then
        bind '"\C-g": "\C-xxfzf-cd-widget\C-m"'
    fi
fi
# -------------------------------
# SSH Agent Setup
# -------------------------------
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

if ! pgrep -u "$USER" ssh-agent >/dev/null 2>&1; then
    eval "$(ssh-agent -a "$SSH_AUTH_SOCK")" >/dev/null
fi

if ! ssh-add -l >/dev/null 2>&1; then
    for key in "$HOME/.ssh/id_github" "$HOME/.ssh/id_ftp" "$HOME/.ssh/id_openweather"; do
        [ -f "$key" ] && ssh-add "$key" 2>/dev/null
    done
fi

# -------------------------------
# Starship Prompt
# -------------------------------
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init bash)"
fi

# -------------------------------
# Zsh-like Options in Bash
# -------------------------------

# autocd: allow changing directory by typing its name
shopt -s autocd

# pushd_ignore_dups: remove duplicates in directory stack
shopt -s cdable_vars

# extended_glob: enable extended globbing (** etc.)
shopt -s extglob
shopt -s globstar

# nonomatch: don’t throw error if glob fails
shopt -s nullglob

# no_clobber: prevent overwriting files with >
set -o noclobber

# notify: report background job completion immediately
set -o notify

# correctall: approximate spell correction (limited in Bash)
# Bash doesn't have full spelling correction; you could define a function if needed

# numericglobsort: sort glob results numerically
# Bash 5+ supports this with globasciiranges=false
shopt -s globasciiranges

# -------------------------------
# History Settings (Zsh-like)
# -------------------------------
HISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/bash/.bash_history"
mkdir -p "$(dirname "$HISTFILE")"

HISTSIZE=10000
HISTFILESIZE=10000
HISTCONTROL=ignoredups:erasedups
shopt -s histappend
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND ; }history -a; history -n"

# Ignore common commands in history
export HISTIGNORE="ls:ls -a:cd:clear:pwd:exit:cd -:cd .."

# -------------------------------
# Optional: Autostart Sway on tty1
# -------------------------------
[[ $(tty) == /dev/tty1 ]] && exec sway
