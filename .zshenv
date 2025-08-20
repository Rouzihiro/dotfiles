# ─────────────────────────────
# Language & Paths
# ─────────────────────────────
export LANG="en_US.UTF-8"

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export ZSH_CACHE_DIR="$XDG_CACHE_HOME/zsh"
export ZSH_COMPDUMP="${ZSH_CACHE_DIR}/.zcompdump-${(%):-%m}-${ZSH_VERSION}"

# ─────────────────────────────
# Editors / Apps
# ─────────────────────────────
export BROWSER="librewolf"
export EDITOR="nvim"
export SUDO_EDITOR="$EDITOR"
export VISUAL="$EDITOR"

# ─────────────────────────────
# Theming
# ─────────────────────────────
export GTK_THEME="Kanagawa-Dark"
export GTK2_RC_FILES="$HOME/.themes/Kanagawa-Dark/gtk-2.0/gtkrc"
export BAT_THEME="Kanagawa-Dark"

# ─────────────────────────────
# Manpages with bat
# ─────────────────────────────
export MANPAGER="sh -c 'col -bx | bat -p -l man'"
export MANROFFOPT="-c"

# ─────────────────────────────
# Development / Debug
# ─────────────────────────────
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export SHADER_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/mesa_shader_cache"
export ANV_DEBUG="video-decode,video-encode"

# ─────────────────────────────
# Autostart sway on tty1
# ─────────────────────────────
[ "$(tty)" = "/dev/tty1" ] && exec sway
