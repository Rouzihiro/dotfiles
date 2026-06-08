# Auto-install zinit if not present
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
ZINIT_ZSH="${ZINIT_HOME}/zinit.zsh"

if [[ ! -f "${ZINIT_ZSH}" ]]; then
    echo "🚀 Installing zinit..."
    rm -rf "${ZINIT_HOME}"
    bash -c "$(curl --fail --show-error --silent --location \
        https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
fi

if [[ -f "${ZINIT_ZSH}" ]]; then
    source "${ZINIT_ZSH}"

    # Load annexes (only needed when installing/updating plugins)
    zinit light-mode for \
        zdharma-continuum/zinit-annex-as-monitor \
        zdharma-continuum/zinit-annex-bin-gem-node \
        zdharma-continuum/zinit-annex-patch-dl \
        zdharma-continuum/zinit-annex-rust
fi


#╔═╗┌─┐┌┐┌  ┌─┐┬ ┬┌┬┐┌─┐  ┌─┐┬─┐┌─┐┌┬┐┌─┐┌┬┐
#╔═╝├┤ │││  └─┐│ │ │││ │  ├─┘├┬┘│ ││││├─┘ │ 
#╚═╝└─┘┘└┘  └─┘└─┘─┴┘└─┘  ┴  ┴└─└─┘┴ ┴┴   ┴ 
export SUDO_PROMPT="$fg[red][sudo] $fg[yellow]password for $USER  :$fg[white]"

#  ╔═╗┬  ┬ ┬┌─┐┬┌┐┌┌─┐
#  ╠═╝│  │ ││ ┬││││└─┐
#  ╩  ┴─┘└─┘└─┘┴┘└┘└─┘
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions

#  ╔═╗┌┐┌┬┌─┐┌─┐┌─┐┌┬┐┌─┐
#  ╚═╗││││├─┘├─┘├┤  │ └─┐
#  ╚═╝┘└┘┴┴  ┴  └─┘ ┴ └─┘
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found

# Detect distribution and load the appropriate plugin
if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    case ${ID} in
        arch)
            zinit snippet OMZP::archlinux
            ;;
        fedora|fedora-asahi-remix)
            local fedora_file="${ZDOTDIR:-$HOME/.config/zsh}/.fedora"
            if [[ -f "$fedora_file" ]]; then
                source "$fedora_file"
            else
                echo "⚠️  Fedora detected but .fedora file not found at: $fedora_file"
            fi
            ;;
        *)
            echo "Unsupported distribution: ${ID}"
            ;;
    esac
else
    echo "Cannot detect distribution: /etc/os-release not found"
fi

# Load syntax highlighting last so it doesn't interfere with completions
zinit light zsh-users/zsh-syntax-highlighting

#  ╔═╗┌─┐┌┬┐┌─┐┬  ┌─┐┌┬┐┬┌─┐┌┐┌   ┬   ╦  ┌─┐┌─┐┌┬┐┬┌┐┌┌─┐  ╔═╗┌┐┌┌─┐┬┌┐┌┌─┐
#  ║  │ ││││├─┘│  ├┤  │ ││ ││││  ┌┼─  ║  │ │├─┤ │││││││ ┬  ║╣ ││││ ┬││││├┤ 
#  ╚═╝└─┘┴ ┴┴  ┴─┘└─┘ ┴ ┴└─┘┘└┘  └┘   ╩═╝└─┘┴ ┴─┴┘┴┘└┘└─┘  ╚═╝┘└┘└─┘┴┘└┘└─┘
autoload -Uz compinit

# Only regenerate dump if it's older than 24h, otherwise skip security check (faster)
if [[ -n ${ZDOTDIR:-$HOME/.config/zsh}/.zcompdump(#qN.mh+24) ]]; then
    compinit -d "${ZDOTDIR:-$HOME/.config/zsh}/.zcompdump"
else
    compinit -C -d "${ZDOTDIR:-$HOME/.config/zsh}/.zcompdump"
fi

autoload -Uz vcs_info
precmd () { vcs_info }
_comp_options+=(globdots)

#  ╔═╗┌─┐┌┬┐┌─┐┬  ┌─┐┌┬┐┬┌─┐┌┐┌┌─┐  ╔═╗┌┬┐┬ ┬┬  ┌─┐
#  ║  │ ││││├─┘│  ├┤  │ ││ ││││└─┐  ╚═╗ │ └┬┘│  ├┤ 
#  ╚═╝└─┘┴ ┴┴  ┴─┘└─┘ ┴ ┴└─┘┘└┘└─┘  ╚═╝ ┴  ┴ ┴─┘└─┘
zstyle ':completion:*' verbose true
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list \
                'm:{a-zA-Z}={A-Za-z}' \
                '+r:|[._-]=* r:|=*' \
                '+l:|=*'
zstyle ':completion:*:warnings' format "%B%F{red}No matches for:%f %F{magenta}%d%b"
zstyle ':completion:*:descriptions' format '%F{yellow}[-- %d --]%f'
zstyle ':vcs_info:*' formats ' %B%s-[%F{magenta}%f %F{yellow}%b%f]-'

#  ╔═╗┬ ┬┌┬┐┌─┐  ┌─┐┬ ┬┌─┐┌─┐┌─┐┌─┐┌┬┐┬┌─┐┌┐┌  ┌─┐┌─┐┌┬┐┌┬┐┬┌┐┌┌─┐┌─┐
#  ╠═╣│ │ │ │ │  └─┐│ ││ ┬│ ┬├┤ └─┐ │ ││ ││││  └─┐├┤  │  │ │││││ ┬└─┐
#  ╩ ╩└─┘ ┴ └─┘  └─┘└─┘└─┘└─┘└─┘└─┘ ┴ ┴└─┘┘└┘  └─┘└─┘ ┴  ┴ ┴┘└┘└─┘└─┘
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

#  ╦ ╦┌─┐┬┌┬┐┬┌┐┌┌─┐  ╔╦╗┌─┐┌┬┐┌─┐
#  ║║║├─┤│ │ │││││ ┬   ║║│ │ │ └─┐
#  ╚╩╝┴ ┴┴ ┴ ┴┘└┘└─┘  ═╩╝└─┘ ┴ └─┘
expand-or-complete-with-dots() {
  echo -n "\e[31m…\e[0m"
  zle expand-or-complete
  zle redisplay
}
zle -N expand-or-complete-with-dots
bindkey "^I" expand-or-complete-with-dots

#  ╦ ╦┬┌─┐┌┬┐┌─┐┬─┐┬ ┬
#  ╠═╣│└─┐ │ │ │├┬┘└┬┘
#  ╩ ╩┴└─┘ ┴ └─┘┴└─ ┴ 
HISTSIZE=20000
SAVEHIST=20000
HISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/history"
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt HIST_REDUCE_BLANKS

#  ╔═╗┌─┐┌┬┐┬┌─┐┌┐┌┌─┐
#  ║ ║├─┘ │ ││ ││││└─┐
#  ╚═╝┴   ┴ ┴└─┘┘└┘└─┘
stty stop undef
setopt interactive_comments
setopt AUTOCD
setopt PROMPT_SUBST
setopt MENU_COMPLETE
setopt LIST_PACKED
setopt AUTO_LIST
setopt COMPLETE_IN_WORD
DIRSTACKSIZE=20
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT

#  ╔═╗┌─┐┌┐┌  ╔═╗┬─┐┌─┐┌┬┐┌─┐┌┬┐
#  ╔═╝├┤ │││  ╠═╝├┬┘│ ││││├─┘ │ 
#  ╚═╝└─┘┘└┘  ╩  ┴└─└─┘┴ ┴┴   ┴ 
function dir_icon {
  if [[ "$PWD" == "$HOME" ]]; then
    echo "%B%F{cyan}%f%b"
  else
    echo "%B%F{cyan}%f%b"
  fi
}
PS1='%B%F{green}%f%b  %B%F{magenta}%n%f%b $(dir_icon)  %B%F{red}%~%f%b${vcs_info_msg_0_} %(?.%B%F{green}.%F{red})%f%b '

#  ╦  ╦┬┌┬┐┌┐ ┬┌┐┌┌┬┐
#  ╚╗╔╝││││├┴┐││││ ││
#   ╚╝ ┴┴ ┴└─┘┴┘└┘─┴┘
bindkey -v
export KEYTIMEOUT=1

function zle-keymap-select () {
    case $KEYMAP in
        vicmd) echo -ne '\e[1 q';;
        viins|main) echo -ne '\e[5 q';;
    esac
}
zle -N zle-keymap-select
zle-line-init(){
    zle -K viins
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q'
preexec() { echo -ne '\e[5 q' ;}

bindkey '^j' history-search-backward
bindkey '^k' history-search-forward
bindkey '^[w' kill-region
bindkey '^y' autosuggest-accept
bindkey -v '^?' backward-delete-char


# Open current command line in nvim for editing
autoload -Uz edit-command-line
zle -N edit-command-line

# Bind in normal mode (press 'v' after Esc)
bindkey -M vicmd v edit-command-line

# Add Ctrl+N for insert mode (so you don't need to press Esc first)
bindkey -M viins '^N' edit-command-line

#  ╔═╗┬ ┬┌─┐┬  ┬    ╦┌┐┌┌┬┐┌─┐┌─┐┬─┐┌─┐┌┬┐┬┌─┐┌┐┌
#  ╚═╗├─┤├┤ │  │    ║│││ │ ├┤ │ ┬├┬┘├─┤ │ ││ ││││
#  ╚═╝┴ ┴└─┘┴─┘┴─┘  ╩┘└┘ ┴ └─┘└─┘┴└─┴ ┴ ┴ ┴└─┘┘└┘

# Cache zoxide init output — invalidate by deleting the cache file after upgrades
_zoxide_cache="${ZSH_CACHE_DIR:-$HOME/.cache/zsh}/zoxide_init.zsh"
if [[ ! -f "$_zoxide_cache" ]]; then
    zoxide init --cmd cd zsh >| "$_zoxide_cache"
fi
source "$_zoxide_cache"
unset _zoxide_cache

eval "$(dircolors -b ${HOME}/.config/zsh/.dircolors 2>/dev/null || dircolors -b)"


# ============================================
# FZF
# ============================================
if command -v fzf >/dev/null 2>&1; then
    for fzf_file in \
        /usr/share/fzf/key-bindings.zsh \
        /usr/share/doc/fzf/examples/key-bindings.zsh \
        /opt/homebrew/opt/fzf/shell/key-bindings.zsh; do
        if [[ -f "$fzf_file" ]]; then
            source "$fzf_file"
            break
        fi
    done

    if ! typeset -f fzf-cd-widget >/dev/null; then
        source <(fzf --zsh 2>/dev/null)
    fi

    bindkey -r '^[c'
    bindkey '^O' fzf-cd-widget
fi

# ============================================
# Git Commit Shortcut
# ============================================
git_commit_with_message() {
  local msg=$BUFFER
  BUFFER="git add --all && git commit --message \"${msg}\""
  zle accept-line
}
zle -N git_commit_with_message
bindkey "^G" git_commit_with_message

# ============================================
# SSH Agent Setup
# ============================================
export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.socket"
if ! pgrep -u "$USER" ssh-agent >/dev/null 2>&1; then
    eval "$(ssh-agent -a "$SSH_AUTH_SOCK")" >/dev/null
fi
if ! ssh-add -l >/dev/null 2>&1; then
    ssh-add ~/.ssh/id_github 2>/dev/null
    ssh-add ~/.ssh/id_ftp 2>/dev/null
    ssh-add ~/.ssh/id_openweather 2>/dev/null
fi

# ============================================
# Starship Prompt
# ============================================
# Cache starship init — invalidate by deleting the cache file after upgrades
if command -v starship >/dev/null 2>&1; then
    _starship_cache="${ZSH_CACHE_DIR:-$HOME/.cache/zsh}/starship_init.zsh"
    if [[ ! -f "$_starship_cache" || "$commands[starship]" -nt "$_starship_cache" ]]; then
        starship init zsh >| "$_starship_cache"
    fi
    source "$_starship_cache"
    unset _starship_cache
fi

# ============================================
# Load Aliases
# ============================================
for file in "${ZDOTDIR:-$HOME/.config/zsh}"/.aliases*; do
    [[ -f "$file" ]] && source "$file"
done

# ============================================
# Sway Autostart
# ============================================
[[ "$(tty)" == "/dev/tty1" ]] && exec sway

source /home/rey/.config/broot/launcher/bash/br
