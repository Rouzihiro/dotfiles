#!/usr/bin/env zsh
# install.zsh
#
# Installs this dotfiles repo onto a (Fedora or Arch) machine:
#   - dotfiles/.config        -> ~/.config        (copied, per-app-folder conflict prompts)
#   - dotfiles/flavors        -> ~/flavors         (symlinked)
#   - dotfiles/.local/bin     -> ~/.local/bin      (copied, per-file conflict prompts)
#   - dotfiles/.bashrc        -> ~/.bashrc         (copied, prompt if exists)
#   - dotfiles/.zshenv        -> ~/.zshenv         (copied, prompt if exists)
#   - dotfiles/.bash_profile  -> ~/.bash_profile   (copied, prompt if exists)
#
# Also checks for / offers to install required dependencies on Fedora or Arch.

set -u

DOTFILES_ROOT="${${(%):-%x}:A:h}"

print -r -- "Using dotfiles repo: $DOTFILES_ROOT"
print -r -- ""

# ───────────────────────────────────────────────
# dependency check
# ───────────────────────────────────────────────

DEPS=(
  fzf
  rg
  magick
  delta
  zsh
  tmux
  nvim
  git
  starship
  broot
  eza
  rofi
)

detect_pkg_manager() {
  if command -v dnf >/dev/null 2>&1; then
    print -r -- "dnf"
  elif command -v pacman >/dev/null 2>&1; then
    print -r -- "pacman"
  else
    print -r -- "unknown"
  fi
}

pkg_name_for() {
  local cmd="$1" mgr="$2"
  case "$cmd" in
    magick)
      [[ "$mgr" == "dnf" ]] && print -r -- "ImageMagick" || print -r -- "imagemagick"
      ;;
    rg)
      print -r -- "ripgrep"
      ;;
    nvim)
      print -r -- "neovim"
      ;;
    delta)
      print -r -- "git-delta"
      ;;
    *)
      print -r -- "$cmd"
      ;;
  esac
}

check_deps() {
  local mgr
  mgr="$(detect_pkg_manager)"

  if [[ "$mgr" == "unknown" ]]; then
    print -ru2 -- "Could not detect dnf or pacman — skipping dependency check."
    return 0
  fi

  print -r -- "Detected package manager: $mgr"

  local -a missing
  local cmd
  for cmd in "${DEPS[@]}"; do
    command -v "$cmd" >/dev/null 2>&1 || missing+=("$cmd")
  done

  if (( ${#missing[@]} == 0 )); then
    print -r -- "All dependencies already installed."
    print -r -- ""
    return 0
  fi

  print -r -- "Missing dependencies: ${missing[*]}"
  print -rn -- "Install them now via $mgr? [y/N] "
  read -r answer

  if [[ "$answer" != "y" && "$answer" != "Y" ]]; then
    print -r -- "Skipping dependency installation."
    print -r -- ""
    return 0
  fi

  local -a pkgs
  for cmd in "${missing[@]}"; do
    pkgs+=("$(pkg_name_for "$cmd" "$mgr")")
  done

  if [[ "$mgr" == "dnf" ]]; then
    sudo dnf install -y "${pkgs[@]}"
  elif [[ "$mgr" == "pacman" ]]; then
    sudo pacman -S --needed "${pkgs[@]}"
  fi

  print -r -- ""
}

# ───────────────────────────────────────────────
# helpers
# ───────────────────────────────────────────────

ask_yn() {
  local prompt="$1"
  local answer
  print -rn -- "$prompt [y/N] "
  read -r answer
  [[ "$answer" == "y" || "$answer" == "Y" ]]
}

# ───────────────────────────────────────────────
# .config — copy, conflict prompts scoped per top-level app folder
# ───────────────────────────────────────────────

install_config() {
  local src_root="$DOTFILES_ROOT/config/.config"
  local tgt_root="$HOME/.config"

  if [[ ! -d "$src_root" ]]; then
    print -r -- ".config not found in dotfiles, skipping."
    return 0
  fi

  mkdir -p "$tgt_root"

  local entry name
  for entry in "$src_root"/*(N); do
    name="${entry:t}"
    local tgt="$tgt_root/$name"

    if [[ ! -e "$tgt" ]]; then
      cp -r -- "$entry" "$tgt"
      print -r -- "installed: .config/$name"
      continue
    fi

    if ask_yn "~/.config/$name already exists. Overwrite with dotfiles version?"; then
      rm -rf -- "$tgt"
      cp -r -- "$entry" "$tgt"
      print -r -- "overwritten: .config/$name"
    else
      print -r -- "kept existing: .config/$name"
    fi
  done
}

# ───────────────────────────────────────────────
# flavors — symlinked
# ───────────────────────────────────────────────

install_flavors() {
  local src="$DOTFILES_ROOT/flavors"
  local tgt="$HOME/flavors"

  if [[ ! -d "$src" ]]; then
    print -r -- "flavors not found in dotfiles, skipping."
    return 0
  fi

  if [[ -e "$tgt" || -L "$tgt" ]]; then
    if [[ -L "$tgt" && "$(readlink -f "$tgt")" == "$(readlink -f "$src")" ]]; then
      print -r -- "~/flavors already symlinked correctly, skipping."
      return 0
    fi

    if ask_yn "~/flavors already exists. Replace with symlink to dotfiles/flavors?"; then
      rm -rf -- "$tgt"
      ln -s -- "$src" "$tgt"
      print -r -- "symlinked: ~/flavors -> $src"
    else
      print -r -- "kept existing: ~/flavors"
    fi
  else
    ln -s -- "$src" "$tgt"
    print -r -- "symlinked: ~/flavors -> $src"
  fi
}

# ───────────────────────────────────────────────
# .local/bin — copy, conflict prompts per file
# ───────────────────────────────────────────────

install_local_bin() {
  local src_root="$DOTFILES_ROOT/config/.local/bin"
  local tgt_root="$HOME/.local/bin"

  if [[ ! -d "$src_root" ]]; then
    print -r -- ".local/bin not found in dotfiles, skipping."
    return 0
  fi

  mkdir -p "$tgt_root"

  local f name tgt
  for f in "$src_root"/*(N); do
    name="${f:t}"
    tgt="$tgt_root/$name"

    if [[ ! -e "$tgt" ]]; then
      cp -- "$f" "$tgt"
      chmod +x "$tgt" 2>/dev/null
      print -r -- "installed: .local/bin/$name"
      continue
    fi

    if cmp -s "$f" "$tgt"; then
      print -r -- "unchanged: .local/bin/$name"
      continue
    fi

    if ask_yn "~/.local/bin/$name already exists and differs. Overwrite?"; then
      cp -- "$f" "$tgt"
      chmod +x "$tgt" 2>/dev/null
      print -r -- "overwritten: .local/bin/$name"
    else
      print -r -- "kept existing: .local/bin/$name"
    fi
  done
}

# ───────────────────────────────────────────────
# shell rc files
# ───────────────────────────────────────────────

install_shell_file() {
  local name="$1"
  local src="$DOTFILES_ROOT/config/$name"
  local tgt="$HOME/$name"

  if [[ ! -f "$src" ]]; then
    print -r -- "$name not found in dotfiles, skipping."
    return 0
  fi

  if [[ ! -e "$tgt" ]]; then
    cp -- "$src" "$tgt"
    print -r -- "installed: $name"
    return 0
  fi

  if cmp -s "$src" "$tgt"; then
    print -r -- "unchanged: $name"
    return 0
  fi

  if ask_yn "~/$name already exists and differs. Overwrite?"; then
    cp -- "$src" "$tgt"
    print -r -- "overwritten: $name"
  else
    print -r -- "kept existing: $name"
  fi
}

# ───────────────────────────────────────────────
# main
# ───────────────────────────────────────────────

check_deps

print -r -- "── .config ──"
install_config
print -r -- ""

print -r -- "── flavors ──"
install_flavors
print -r -- ""

print -r -- "── .local/bin ──"
install_local_bin
print -r -- ""

print -r -- "── shell rc files ──"
install_shell_file ".bashrc"
install_shell_file ".zshenv"
install_shell_file ".bash_profile"
print -r -- ""

print -r -- "Done."
