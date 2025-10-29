# ─────────────────────────────
# Language & Paths
# ─────────────────────────────
export LANG="en_US.UTF-8"
#export LC_ALL="en_US.UTF-8"

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export ZSH_CACHE_DIR="$XDG_CACHE_HOME/zsh"
export ZSH_COMPDUMP="${ZSH_CACHE_DIR}/.zcompdump-${(%):-%m}-${ZSH_VERSION}"

# ─────────────────────────────
# Editors / Apps
# ─────────────────────────────
export BROWSER="brave"
export EDITOR="nvim"
export SUDO_EDITOR="$EDITOR"
export VISUAL="$EDITOR"

# ─────────────────────────────
# Theming
# ─────────────────────────────
export GTK_THEME="Nightfox-Dark"
export GTK2_RC_FILES="$HOME/.themes/Nightfox-Dark/gtk-2.0/gtkrc"
export BAT_THEME="Nightfox-Dark"

# ─────────────────────────────
# Manpages with bat
# ─────────────────────────────
export MANPAGER="sh -c 'col -bx | bat -p -l man'"
export MANROFFOPT="-c"

# ─────────────────────────────
# Development / Debug
# ─────────────────────────────
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export SHADER_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/shader_cache"  # custom shader cache
export ANV_DEBUG="video-decode,video-encode"

export BEMENU_OPTS="--fn 'JetBrainsMono Nerd Font 12' \
  --center --line-height 22 --margin 8 --width-factor 0.5 \
  --nb '#2e3440' --nf '#cdcecf' \
  --hb '#81b29a' --hf '#192330' \
  --tb '#2e3440' --tf '#f6c177' \
  --fb '#2e3440' --ff '#cdcecf' \
  --list 20 --prompt '>'"
