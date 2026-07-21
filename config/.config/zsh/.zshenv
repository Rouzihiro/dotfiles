# ─────────────────────────────
# Language & Paths
# ─────────────────────────────
export LANG="en_US.UTF-8"
#export LC_ALL="en_US.UTF-8"
export ZSH_CACHE_DIR="$XDG_CACHE_HOME/zsh"
export DOTFILES_DIR="$HOME/dotfiles"
export PROJECTS_DIR="$HOME/Projects"
export SUCKLESS_DIR="$HOME/suckless"

# ─────────────────────────────
# PATH (set here so subshells inherit it without re-running loops)
# ─────────────────────────────
export PATH="$HOME/bin:$HOME/.local/bin:/usr/local/bin:$HOME/.dotnet/tools:$HOME/.cargo/bin:$PATH"

# Add subfolders inside ~/.local/bin (done once here, not on every shell)
for dir in "$HOME/.local/bin/"*/; do
    [[ -d "$dir" ]] && export PATH="$dir:$PATH"
done
unset dir

# ─────────────────────────────
# Editors / Apps
# ─────────────────────────────
# export NVIM_LISTEN_ADDRESS="/tmp/nvim-theme.sock"
export EDITOR="nvim"
export SUDO_EDITOR="$EDITOR"
export VISUAL="$EDITOR"
export BROWSER="zen-browser"
export MOZ_ENABLE_WAYLAND=1

# ─────────────────────────────
# Manpages with bat
# ─────────────────────────────
export MANPAGER="sh -c 'col -bx | bat -p -l man'"
export MANROFFOPT="-c"

# ─────────────────────────────
# Development / Debug
# ─────────────────────────────
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export SHADER_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/shader_cache"
# export ANV_DEBUG="video-decode,video-encode"  # uncomment only when debugging

export LF_ICONS="di=📁:fi=📄:ln=🔗:ex=⚡:*.pdf=📄:*.jpg=🖼️:*.png=🖼️:*.mp4=🎬"

export BEMENU_OPTS="--fn 'JetBrainsMono Nerd Font 12' --center --line-height 22 --margin 8 --width-factor 0.5 --nb '#2e3440' --nf '#cdcecf' --hb '#81b29a' --hf '#192330' --tb '#2e3440' --tf '#f6c177' --fb '#2e3440' --ff '#cdcecf' --list 20 --prompt '>'"


if [ -z "$XDG_RUNTIME_DIR" ]; then
  export XDG_RUNTIME_DIR=/run/user/$(id -u)
  mkdir -p "$XDG_RUNTIME_DIR"
  chmod 0700 "$XDG_RUNTIME_DIR"
fi

# cashout potential
ulimit -c 0
