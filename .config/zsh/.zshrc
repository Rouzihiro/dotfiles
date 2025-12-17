# Auto-install zinit if not present
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
ZINIT_ZSH="${ZINIT_HOME}/zinit.zsh"

# Install zinit if missing
if [[ ! -f "${ZINIT_ZSH}" ]]; then
    echo "🚀 Installing zinit..."
    rm -rf "${ZINIT_HOME}"
    bash -c "$(curl --fail --show-error --silent --location \
        https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
fi

# Load zinit if available
if [[ -f "${ZINIT_ZSH}" ]]; then
    source "${ZINIT_ZSH}"
    
    # Load important annexes (zinit extensions) - MOVED HERE FROM END OF FILE
    zinit light-mode for \
        zdharma-continuum/zinit-annex-as-monitor \
        zdharma-continuum/zinit-annex-bin-gem-node \
        zdharma-continuum/zinit-annex-patch-dl \
        zdharma-continuum/zinit-annex-rust
fi


#╔═╗┌─┐┌┐┌  ┌─┐┬ ┬┌┬┐┌─┐  ┌─┐┬─┐┌─┐┌┬┐┌─┐┌┬┐
#╔═╝├┤ │││  └─┐│ │ │││ │  ├─┘├┬┘│ ││││├─┘ │ 
#╚═╝└─┘┘└┘  └─┘└─┘─┴┘└─┘  ┴  ┴└─└─┘┴ ┴┴   ┴ 
export SUDO_PROMPT="$fg[red][sudo] $fg[yellow]password for $USER  :$fg[white]"

#  ╔═╗┬  ┬ ┬┌─┐┬┌┐┌┌─┐
#  ╠═╝│  │ ││ ┬││││└─┐
#  ╩  ┴─┘└─┘└─┘┴┘└┘└─┘
zinit light zsh-users/zsh-syntax-highlighting
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
            # Source local .fedora file
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

#  ╔═╗┌─┐┌┬┐┌─┐┬  ┌─┐┌┬┐┬┌─┐┌┐┌   ┬   ╦  ┌─┐┌─┐┌┬┐┬┌┐┌┌─┐  ╔═╗┌┐┌┌─┐┬┌┐┌┌─┐
#  ║  │ ││││├─┘│  ├┤  │ ││ ││││  ┌┼─  ║  │ │├─┤ │││││││ ┬  ║╣ ││││ ┬││││├┤ 
#  ╚═╝└─┘┴ ┴┴  ┴─┘└─┘ ┴ ┴└─┘┘└┘  └┘   ╩═╝└─┘┴ ┴─┴┘┴┘└┘└─┘  ╚═╝┘└┘└─┘┴┘└┘└─┘
autoload -Uz compinit 

for dump in ~/.config/zsh/zcompdump(N.mh+24); do
  compinit -d ~/.config/zsh/zcompdump
done

compinit -C -d ~/.config/zsh/zcompdump

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
zstyle ':vcs_info:*' formats ' %B%s-[%F{magenta}%f %F{yellow}%b%f]-'

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
HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/history"
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

#  ╔═╗┌─┐┌┬┐┬┌─┐┌┐┌┌─┐
#  ║ ║├─┘ │ ││ ││││└─┐
#  ╚═╝┴   ┴ ┴└─┘┘└┘└─┘
stty stop undef             # Disable ctrl-s to freeze terminal.
setopt interactive_comments
setopt AUTOCD               # change directory just by typing its name
setopt PROMPT_SUBST         # enable command substitution in prompt
setopt MENU_COMPLETE        # Automatically highlight first element of completion menu
setopt LIST_PACKED          # The completion menu takes less space.
setopt AUTO_LIST            # Automatically list choices on ambiguous completion.
setopt COMPLETE_IN_WORD     # Complete from both ends of a word.


#  ╔═╗┌─┐┌┐┌  ╔═╗┬─┐┌─┐┌┬┐┌─┐┌┬┐
#  ╔═╝├┤ │││  ╠═╝├┬┘│ ││││├─┘ │ 
#  ╚═╝└─┘┘└┘  ╩  ┴└─└─┘┴ ┴┴   ┴ 
function dir_icon {
  if [[ "$PWD" == "$HOME" ]]; then
    echo "%B%F{cyan}%f%b"
  else
    echo "%B%F{cyan}%f%b"
  fi
}
PS1='%B%F{green}%f%b  %B%F{magenta}%n%f%b $(dir_icon)  %B%F{red}%~%f%b${vcs_info_msg_0_} %(?.%B%F{green}.%F{red})%f%b '

#  ╦  ╦┬┌┬┐┌┐ ┬┌┐┌┌┬┐
#  ╚╗╔╝││││├┴┐││││ ││
#   ╚╝ ┴┴ ┴└─┘┴┘└┘─┴┘
bindkey -v
export KEYTIMEOUT=1

#Cursor Shapes For Different Vim Mode
#Cursor style cheat sheet
# Set cursor style (DECSCUSR), VT520.
# 0  ⇒  blinking block.
# 1  ⇒  blinking block (default).
# 2  ⇒  steady block.
# 3  ⇒  blinking underline.
# 4  ⇒  steady underline.
# 5  ⇒  blinking bar, xterm.
# 6  ⇒  steady bar, xterm.

function zle-keymap-select () {
    case $KEYMAP in
        vicmd) echo -ne '\e[1 q';;  #block
        viins|main) echo -ne '\e[5 q';; #beam
    esac
}
zle -N zle-keymap-select
zle-line-init(){
    zle -K viins # initiate vi insert as keymap (can be removed if 'bindkey -v' has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup
preexec() { echo -ne '\e[5 q' ;} # USE beam shape cursor for each new prompt

bindkey '^j' history-search-backward
bindkey '^k' history-search-forward
bindkey '^[w' kill-region
bindkey '^y' autosuggest-accept
bindkey -v '^?' backward-delete-char

#  ╔═╗┬ ┬┌─┐┬  ┬    ╦┌┐┌┌┬┐┌─┐┌─┐┬─┐┌─┐┌┬┐┬┌─┐┌┐┌
#  ╚═╗├─┤├┤ │  │    ║│││ │ ├┤ │ ┬├┬┘├─┤ │ ││ ││││
#  ╚═╝┴ ┴└─┘┴─┘┴─┘  ╩┘└┘ ┴ └─┘└─┘┴└─┴ ┴ ┴ ┴└─┘┘└┘
eval "$(zoxide init --cmd cd zsh)"

eval "$(dircolors -b ${HOME}/.config/zsh/.dircolors 2>/dev/null || dircolors -b)"
export PATH="$HOME/.local/bin:$HOME/.local/share/bob/nightly/bin:/usr/local/bin:$PATH:$HOME/.dotnet/tools"

# Add subfolders inside ~/.local/bin
for dir in "$HOME/.local/bin/"*/; do
    [ -d "$dir" ] && export PATH="$dir:$PATH"
done

export PATH="$HOME/.cargo/bin:$PATH"

# ============================================
# FZF
# ============================================
if command -v fzf >/dev/null 2>&1; then
    # Try different source locations
    for fzf_file in \
        /usr/share/fzf/key-bindings.zsh \
        /usr/share/doc/fzf/examples/key-bindings.zsh \
        /opt/homebrew/opt/fzf/shell/key-bindings.zsh; do
        if [[ -f "$fzf_file" ]]; then
            source "$fzf_file"
            break
        fi
    done
    
    # Fallback to generating
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
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
fi

# ============================================
# Load Aliases
# ============================================
for file in "${ZDOTDIR:-$HOME/.config/zsh}"/.aliases*; do
    [ -f "$file" ] && source "$file"
done

# ============================================
# Sway Autostart
# ============================================
[ "$(tty)" = "/dev/tty1" ] && exec sway
