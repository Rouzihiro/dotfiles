#!/bin/bash
# =====================================================
# Fedora ARM Setup Script (Dotfiles Installer)
# Compatible with Fedora Workstation/Asahi/ARM
# =====================================================

set -o pipefail

# -------------------------------
# Variables
# -------------------------------
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
DOTFILES_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
BACKUP_DIR="$HOME/.bkp_config_$(date +%Y%m%d_%H%M%S)"
LOG_FILE="$HOME/.logs/installer-log.txt"
PKGS_DIR="$SCRIPT_DIR/pkgs"

# Try sourcing from PATH first, then fall back to the shared root-level copy
if ! source Global_functions.sh 2>/dev/null; then
    if ! source "$DOTFILES_ROOT/install/Global_functions.sh"; then
        echo "Failed to source Global_functions.sh"
        exit 1
    fi
fi

# -------------------------------
# Logging
# -------------------------------
log() {
    [[ ! -d "$(dirname "$LOG_FILE")" ]] && mkdir -p "$(dirname "$LOG_FILE")"
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

error() {
    [[ ! -d "$(dirname "$LOG_FILE")" ]] && mkdir -p "$(dirname "$LOG_FILE")"
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] [ERROR] $*" | tee -a "$LOG_FILE" >&2
}

# -------------------------------
# Root check
# -------------------------------
if [[ $EUID -eq 0 ]]; then
    error "Do NOT run this script as root!"
    exit 1
fi

# -------------------------------
# Ensure fzf installed
# -------------------------------
if ! command -v fzf &>/dev/null; then
    log "fzf not found, installing..."
    sudo dnf install -y fzf 2>&1 | tee -a "$LOG_FILE"
fi

# -------------------------------
# Ensure zsh installed (needed for install.zsh)
# -------------------------------
if ! command -v zsh &>/dev/null; then
    log "zsh not found, installing..."
    sudo dnf install -y zsh 2>&1 | tee -a "$LOG_FILE"
fi

# -------------------------------
# Functions
# -------------------------------
update_system() {
    log "Updating system..."
    sudo dnf upgrade -y 2>&1 | tee -a "$LOG_FILE"
}

install_packages() {
    if [[ ! -d "$PKGS_DIR" ]]; then
        error "Package directory '$PKGS_DIR' not found."
        return
    fi

    log "Select package groups (TAB to multi-select, ENTER to confirm):"
    SELECTED=$(find "$PKGS_DIR" -type f -print | fzf --multi --prompt="Select groups: " --ansi)
    [[ -z "$SELECTED" ]] && { log "No groups selected."; return; }

    PACKAGES=()
    while IFS= read -r file; do
        while IFS= read -r pkg || [[ -n "$pkg" ]]; do
            [[ -z "$pkg" || "$pkg" =~ ^[[:space:]]*# ]] && continue
            PACKAGES+=("$pkg")
        done < "$file"
    done <<< "$SELECTED"

    log "Installing selected packages..."
    if ! sudo dnf install -y "${PACKAGES[@]}" 2>&1 | tee -a "$LOG_FILE"; then
        error "Some packages failed to install."
    fi
}

enable_copr_repos() {
    local copr_file="$PKGS_DIR/copr.txt"
    [[ ! -f "$copr_file" ]] && { log "No copr.txt found, skipping COPR repos."; return; }

    log "Enabling COPR repos..."
    while IFS= read -r repo || [[ -n "$repo" ]]; do
        [[ -z "$repo" || "$repo" =~ ^[[:space:]]*# ]] && continue
        log "Enabling COPR repo: $repo"
        sudo dnf copr enable -y "$repo" 2>&1 | tee -a "$LOG_FILE"
    done < "$copr_file"
}

install_copr_packages() {
    local copr_file="$PKGS_DIR/copr.txt"
    [[ ! -f "$copr_file" ]] && { log "No copr.txt found, skipping COPR packages."; return; }

    log "Installing packages from COPR..."
    while IFS= read -r repo || [[ -n "$repo" ]]; do
        [[ -z "$repo" || "$repo" =~ ^[[:space:]]*# ]] && continue
        log "Enabling COPR repo: $repo"
        sudo dnf copr enable -y "$repo" 2>&1 | tee -a "$LOG_FILE"

        pkg=$(basename "$repo")
        log "Installing package from COPR: $pkg"
        sudo dnf install -y "$pkg" 2>&1 | tee -a "$LOG_FILE"
    done < "$copr_file"
}

link_configs() {
    log "Launching install.sh for config/dotfiles placement..."
    if [[ -f "$DOTFILES_ROOT/install.sh" ]]; then
        bash "$DOTFILES_ROOT/install.sh" 2>&1 | tee -a "$LOG_FILE"
    else
        error "install.sh not found at $DOTFILES_ROOT/install.sh"
    fi
}

setup_zsh() {
    log "Installing Zinit..."

    local ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
    local ZDOTDIR="${ZDOTDIR:-${HOME}/.config/zsh}"
    local ZCACHEDIR="${XDG_CACHE_HOME:-${HOME}/.cache}/zsh"

    if [[ ! -f "$ZINIT_HOME/zinit.zsh" ]]; then
        log "Cloning Zinit..."
        mkdir -p "$(dirname "$ZINIT_HOME")"
        git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME" --depth 1 2>&1 | tee -a "$LOG_FILE"
        log "Zinit installed."
    else
        log "Zinit already installed. Updating..."
        cd "$ZINIT_HOME" && git pull 2>&1 | tee -a "$LOG_FILE"
    fi

    log "Creating Zsh directories..."
    mkdir -p "$ZDOTDIR"
    mkdir -p "$ZCACHEDIR"
    mkdir -p "${HOME}/.local/bin"

    if [[ "$SHELL" != "/bin/zsh" ]] && [[ "$SHELL" != "/usr/bin/zsh" ]]; then
        log "Changing default shell to zsh..."
        chsh -s /bin/zsh 2>&1 | tee -a "$LOG_FILE"
    else
        log "Zsh is already the default shell."
    fi

    log "Zsh setup complete!"
}

switch_git_remote() {
    if git -C "$DOTFILES_ROOT" rev-parse --is-inside-work-tree &>/dev/null; then
        current=$(git -C "$DOTFILES_ROOT" remote get-url origin)
        if [[ "$current" =~ ^https://github.com/ ]]; then
            user_repo=$(echo "$current" | sed -E 's#https://github.com/(.+)#\1#')
            new="git@github.com:$user_repo"
            git -C "$DOTFILES_ROOT" remote set-url origin "$new"
            log "Switched remote to SSH: $new"
        else
            log "Remote already using SSH: $current"
        fi
    else
        error "Not inside a git repository at $DOTFILES_ROOT."
    fi
}

setup_groups_and_uinput() {
    groups=("scanner" "wheel" "audio" "input" "lp" "storage" "video" "fuse" "docker")
    read -p "Enter the username to add to groups: " username
    [[ ! $(id "$username" 2>/dev/null) ]] && { error "User $username does not exist."; return; }
    for group in "${groups[@]}"; do
        [[ ! $(getent group "$group") ]] && sudo groupadd "$group" && log "Group '$group' created."
        sudo usermod -aG "$group" "$username" && log "User $username added to group '$group'."
    done

    echo 'KERNEL=="uinput", MODE="0660", GROUP="input"' | sudo tee /etc/udev/rules.d/99-uinput.rules >/dev/null
    sudo udevadm control --reload-rules
    sudo udevadm trigger

    read -p "Load uinput module now? (y/N): " answer
    [[ "$answer" =~ ^[Yy]$ ]] && sudo modprobe uinput && log "uinput loaded."
}

# -------------------------------
# Menu
# -------------------------------
OPTIONS=(
    "Update system"
    "Install packages"
    "Enable COPR repos"
    "Install COPR packages"
    "Link configs/dotfiles"
    "Setup Zsh + plugins"
    "Switch Git remote (HTTPS <-> SSH)"
    "Setup user groups + uinput"
    "Quit"
)

while true; do
    CHOICE=$(printf '%s\n' "${OPTIONS[@]}" | fzf --prompt="Select task: " --height=15 --reverse)
    case $CHOICE in
        "Update system") update_system ;;
        "Install packages") install_packages ;;
        "Enable COPR repos") enable_copr_repos ;;
        "Install COPR packages") install_copr_packages ;;
        "Link configs/dotfiles") link_configs ;;
        "Setup Zsh + plugins") setup_zsh ;;
        "Switch Git remote (HTTPS <-> SSH)") switch_git_remote ;;
        "Setup user groups + uinput") setup_groups_and_uinput ;;
        "Quit") log "Goodbye!"; break ;;
        *) error "Invalid choice";;
    esac
done

log "All done. Backups (if any) are in $BACKUP_DIR. Errors (if any) are in $LOG_FILE"
