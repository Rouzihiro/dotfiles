#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

log_info()    { echo -e "${GREEN}[INFO]${NC} $*"; }
log_warning() { echo -e "${YELLOW}[WARN]${NC} $*"; }
log_error()   { echo -e "${RED}[ERROR]${NC} $*"; }
log_success() { echo -e "${CYAN}[SUCCESS]${NC} $*"; }

# GitHub URLs
GITHUB_PACMAN_BASE="https://raw.githubusercontent.com/Rouzihiro/dotfiles/main/install/pacman"
GITHUB_AUR_BASE="https://raw.githubusercontent.com/Rouzihiro/dotfiles/main/install/aur"
GITHUB_SCRIPTS_API="https://api.github.com/repos/Rouzihiro/dotfiles/contents/scripts"
GITHUB_SCRIPTS_BASE="https://raw.githubusercontent.com/Rouzihiro/dotfiles/main/scripts"

TMPDIR=$(mktemp -d)
cleanup() {
  rm -rf "$TMPDIR"
}
trap cleanup EXIT

# Dependency check
check_dependencies() {
  for cmd in fzf jq curl sudo pacman; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
      log_error "Required command '$cmd' is missing. Please install it and rerun."
      exit 1
    fi
  done
}

# Fetch package list filenames (pacman or aur)
fetch_package_list_files() {
  local repo="$1"
  curl -s "https://api.github.com/repos/Rouzihiro/dotfiles/contents/install/${repo}" | jq -r '.[].name' | grep '\.txt$'
}

# Read packages from file
read_packages_from_file() {
  local file="$1"
  local -n arr_ref="$2"
  while IFS= read -r line || [[ -n "$line" ]]; do
    [[ "$line" =~ ^#.*$ ]] && continue
    [[ -z "$line" ]] && continue
    arr_ref+=("$line")
  done < "$file"
}

# Select package files via fzf multi-select
select_package_files() {
  local files=("$@")
  echo -e "\n${CYAN}Select package groups to install (multi-select with TAB):${NC}"
  local selected
  selected=$(printf '%s\n' "${files[@]}" | fzf --multi --height=15 --border --prompt="Packages > ")
  mapfile -t selected_files <<<"$selected"
  echo "${selected_files[@]}"
}

# Install pacman packages
install_pacman_packages() {
  local pkgs=("$@")
  if [ "${#pkgs[@]}" -eq 0 ]; then
    log_info "No packages selected for installation."
    return
  fi
  log_info "Installing ${#pkgs[@]} packages via pacman..."
  if ! sudo pacman -S --needed --noconfirm "${pkgs[@]}"; then
    log_warning "Some packages failed to install."
    read -rp "Continue anyway? (y/n): " yn
    [[ "$yn" != [yY]* ]] && exit 1
  fi
  log_success "Pacman packages installed."
}

# Install AUR packages via yay
install_aur_packages() {
  local pkgs=("$@")
  if [ "${#pkgs[@]}" -eq 0 ]; then
    log_info "No AUR packages selected."
    return
  fi
  log_info "Installing ${#pkgs[@]} AUR packages via yay..."
  if ! yay -S --needed --noconfirm "${pkgs[@]}"; then
    log_warning "Some AUR packages failed to install."
    read -rp "Continue anyway? (y/n): " yn
    [[ "$yn" != [yY]* ]] && exit 1
  fi
  log_success "AUR packages installed (or attempted)."
}

install_yay() {
  log_info "Checking for yay AUR helper..."
  if command -v yay >/dev/null 2>&1; then
    log_info "Yay is already installed."
    return
  fi
  log_info "Installing yay..."
  sudo pacman -S --needed --noconfirm git base-devel
  local temp_dir
  temp_dir=$(mktemp -d)
  git clone https://aur.archlinux.org/yay.git "$temp_dir"
  pushd "$temp_dir" >/dev/null
  makepkg -si --noconfirm
  popd >/dev/null
  rm -rf "$temp_dir"
  log_success "Yay installed."
}

install_omz() {
  log_info "Installing Oh My Zsh (no config copying)..."
  if ! command -v zsh >/dev/null 2>&1; then
    log_error "Zsh is not installed. Please install it first."
    return 1
  fi
  if [ -d "$HOME/.oh-my-zsh" ]; then
    log_info "Oh My Zsh already installed."
  else
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    log_success "Oh My Zsh installed."
  fi
}

backup_configs() {
  read -rp "Create backup of current configs? [y/N]: " backup_choice
  if [[ "$backup_choice" =~ ^[Yy]$ ]]; then
    local backup_dir="$HOME/reydots_backup_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$backup_dir"
    log_success "Backup directory created at $backup_dir"
    # Add backup commands here if desired
  else
    log_info "Skipping backup."
  fi
}

update_system() {
  log_info "Updating system packages..."
  sudo pacman -Syu --noconfirm || log_warning "System update completed with warnings."
}

# Utilities menu - numbered list, fetch scripts from GitHub, cache & run
utilities_menu() {
  local cache_dir="$HOME/.local/share/reydots_scripts"
  mkdir -p "$cache_dir"

  log_info "Fetching available utility scripts from GitHub..."

  local scripts_json
  scripts_json=$(curl -s "$GITHUB_SCRIPTS_API")

  if [[ -z "$scripts_json" ]]; then
    log_error "Failed to fetch scripts list."
    return
  fi

  local script_names
  mapfile -t script_names < <(echo "$scripts_json" | jq -r '.[] | select(.type=="file") | .name')

  if [ "${#script_names[@]}" -eq 0 ]; then
    log_warning "No scripts found in the repository."
    return
  fi

  echo -e "\nAvailable Utility Scripts:"
  local i=1
  for script in "${script_names[@]}"; do
    echo "  [$i] $script"
    ((i++))
  done

  echo
  read -rp "Enter the number of the script to run (or 0 to cancel): " choice
  if [[ ! "$choice" =~ ^[0-9]+$ ]]; then
    log_warning "Invalid input."
    return
  fi

  if [ "$choice" -eq 0 ]; then
    log_info "Cancelled."
    return
  fi

  if (( choice < 1 || choice > ${#script_names[@]} )); then
    log_warning "Choice out of range."
    return
  fi

  local selected_script="${script_names[choice-1]}"
  local script_path="$cache_dir/$selected_script"

  if [ ! -f "$script_path" ]; then
    log_info "Downloading $selected_script ..."
    curl -sfL "$GITHUB_SCRIPTS_BASE/$selected_script" -o "$script_path" || {
      log_error "Failed to download $selected_script"
      return
    }
  else
    log_info "$selected_script already cached locally."
  fi

  chmod +x "$script_path"
  echo -e "${YELLOW}--- Begin output of $selected_script ---${NC}"
  "$script_path"
  echo -e "${YELLOW}--- End output of $selected_script ---${NC}"
}

main_menu() {
  local options=(
    "Install Pacman Packages"
    "Install AUR Packages"
    "Utilities"
    "Backup Configs"
    "Update System"
    "Install yay AUR helper"
    "Install Oh My Zsh"
    "Exit"
  )
  while true; do
    echo
    local choice
    choice=$(printf '%s\n' "${options[@]}" | fzf --height=12 --border --prompt="Select an option > ")

    case "$choice" in
      "Install Pacman Packages")
        local pacman_files
        mapfile -t pacman_files < <(fetch_package_list_files "pacman")
        if [ "${#pacman_files[@]}" -eq 0 ]; then
          log_error "No pacman package list files found on GitHub."
          continue
        fi
        local selected_files
        mapfile -t selected_files < <(select_package_files "${pacman_files[@]}")
        if [ "${#selected_files[@]}" -eq 0 ]; then
          log_info "No pacman package groups selected."
          continue
        fi
        local packages=()
        for f in "${selected_files[@]}"; do
          log_info "Fetching $f ..."
          curl -fsSL "${GITHUB_PACMAN_BASE}/${f}" -o "${TMPDIR}/${f}" || {
            log_warning "Failed to download $f"
            continue
          }
          read_packages_from_file "${TMPDIR}/${f}" packages
        done
        install_pacman_packages "${packages[@]}"
        ;;
      "Install AUR Packages")
        local aur_files
        mapfile -t aur_files < <(fetch_package_list_files "aur")
        if [ "${#aur_files[@]}" -eq 0 ]; then
          log_error "No AUR package list files found on GitHub."
          continue
        fi
        local selected_files
        mapfile -t selected_files < <(select_package_files "${aur_files[@]}")
        if [ "${#selected_files[@]}" -eq 0 ]; then
          log_info "No AUR package groups selected."
          continue
        fi
        local packages=()
        for f in "${selected_files[@]}"; do
          log_info "Fetching $f ..."
          curl -fsSL "${GITHUB_AUR_BASE}/${f}" -o "${TMPDIR}/${f}" || {
            log_warning "Failed to download $f"
            continue
          }
          read_packages_from_file "${TMPDIR}/${f}" packages
        done
        install_aur_packages "${packages[@]}"
        ;;
      "Utilities")
        utilities_menu
        ;;
      "Backup Configs")
        backup_configs
        ;;
      "Update System")
        update_system
        ;;
      "Install yay AUR helper")
        install_yay
        ;;
      "Install Oh My Zsh")
        install_omz
        ;;
      "Exit")
        log_info "Goodbye!"
        exit 0
        ;;
      *)
        log_warning "No valid selection made."
        ;;
    esac
  done
}

# Run
check_dependencies
main_menu

