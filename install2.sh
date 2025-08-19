#!/bin/bash

# -------------------------------
# Strict mode (keeps interactive prompts working)
# -------------------------------
set -o pipefail

# -------------------------------
# Variables
# -------------------------------
SCRIPT_DIR=$(pwd)
BACKUP_DIR="$HOME/.bkp_config_$(date +%Y%m%d_%H%M%S)"
LOG_FILE="$HOME/Documents/installer-log.txt"
PKGS_DIR="$SCRIPT_DIR/pkgs"

mkdir -p "$BACKUP_DIR"
mkdir -p "$(dirname "$LOG_FILE")"

# -------------------------------
# Logging
# -------------------------------
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}
error() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] [ERROR] $*" | tee -a "$LOG_FILE" >&2
}

# -------------------------------
# Check root
# -------------------------------
if [[ $EUID -eq 0 ]]; then
    error "Do NOT run as root"
    exit 1
fi

# -------------------------------
# Ensure fzf is installed
# -------------------------------
if ! command -v fzf &>/dev/null; then
    log "fzf not found, installing..."
    sudo pacman -S --needed --noconfirm fzf &>> "$LOG_FILE"
fi

# -------------------------------
# Symlink helper (idempotent + safe backups)
# -------------------------------
backup_and_link() {
    local source="$1"
    local target="$2"

    # ensure parent dir exists
    mkdir -p "$(dirname "$target")"

    if [[ ! -e "$source" && ! -L "$source" ]]; then
        error "Source $source does not exist; skipping."
        return
    fi

    # If target is a symlink and already points (resolving) to source, skip
    if [[ -L "$target" ]]; then
        local target_resolved
        target_resolved="$(readlink -f "$target" 2>/dev/null || true)"
        local source_resolved
        source_resolved="$(readlink -f "$source" 2>/dev/null || true)"
        if [[ -n "$target_resolved" && -n "$source_resolved" && "$target_resolved" == "$source_resolved" ]]; then
            log "$target already symlinked to $source; skipping."
            return
        fi
        log "Backing up existing symlink $target -> $BACKUP_DIR/"
        mv "$target" "$BACKUP_DIR/"
    elif [[ -e "$target" ]]; then
        log "Backing up existing $target -> $BACKUP_DIR/"
        mv "$target" "$BACKUP_DIR/"
    fi

    log "Linking $source -> $target"
    ln -s "$source" "$target"
}

# -------------------------------
# Task functions
# -------------------------------

update_system() {
    log "Updating system..."
    sudo pacman -Syu --noconfirm &>> "$LOG_FILE"
}

install_packages() {
    if [[ ! -d "$PKGS_DIR" ]]; then
        error "Package directory '$PKGS_DIR' not found."
        return
    fi
    log "Select package groups (TAB to multi-select, ENTER to confirm):"
    SELECTED=$(find "$PKGS_DIR" -type f -print | fzf --multi --prompt="Select groups: " --ansi)
    [[ -z "$SELECTED" ]] && { log "No groups selected"; return; }

    PACKAGES=()
    while IFS= read -r file; do
        while IFS= read -r pkg || [[ -n "$pkg" ]]; do
            [[ "$pkg" =~ ^#.*$ || -z "$pkg" ]] && continue
            PACKAGES+=("$pkg")
        done < "$file"
    done <<< "$SELECTED"

    if ! command -v yay &>/dev/null; then
        log "Installing yay..."
        sudo pacman -S --needed --noconfirm git base-devel &>> "$LOG_FILE"
        TEMP_DIR=$(mktemp -d)
        git clone https://aur.archlinux.org/yay.git "$TEMP_DIR" &>> "$LOG_FILE"
        (cd "$TEMP_DIR" && makepkg -si --noconfirm &>> "$LOG_FILE")
        rm -rf "$TEMP_DIR"
    fi

    for pkg in "${PACKAGES[@]}"; do
        if yay -Q "$pkg" &>/dev/null; then
            log "$pkg already installed"
        else
            log "Installing $pkg..."
            yay -S --noconfirm "$pkg" &>> "$LOG_FILE" || error "Failed to install $pkg"
        fi
    done
}

link_configs() {
    log "Linking .config subfolders (directory symlinks)..."
    # Link every item inside repo .config as ~/.config/<name>
    if [[ -d "$SCRIPT_DIR/.config" ]]; then
        for folder in "$SCRIPT_DIR/.config/"*; do
            [[ -e "$folder" ]] || continue
            local name
            name="$(basename "$folder")"
            local target="$HOME/.config/$name"
            backup_and_link "$folder" "$target"
        done
    else
        log "No .config directory in repo; skipping."
    fi

    log "Linking .local/bin as ONE symlink..."
    backup_and_link "$SCRIPT_DIR/.local/bin" "$HOME/.local/bin"

    log "Linking .local/share/applications as ONE symlink..."
    backup_and_link "$SCRIPT_DIR/.local/share/applications" "$HOME/.local/share/applications"

    log "Linking .local/share/icons as ONE symlink..."
    backup_and_link "$SCRIPT_DIR/.local/share/icons" "$HOME/.local/share/icons"
}

setup_zsh() {
    log "Linking .zshenv (symlink + backup)..."
    backup_and_link "$SCRIPT_DIR/.zshenv" "$HOME/.zshenv"

    log "Installing Oh My Zsh..."
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        git clone https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh" &>> "$LOG_FILE"
    else
        log "Oh My Zsh already present; skipping clone."
    fi

    log "Installing Oh My Zsh plugins..."
    OMZ_CUSTOM="$HOME/.oh-my-zsh/custom"
    mkdir -p "$OMZ_CUSTOM/plugins"
    if [[ ! -d "$OMZ_CUSTOM/plugins/zsh-autosuggestions" ]]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions.git "$OMZ_CUSTOM/plugins/zsh-autosuggestions" &>> "$LOG_FILE"
    else
        log "zsh-autosuggestions already present; skipping."
    fi
    if [[ ! -d "$OMZ_CUSTOM/plugins/zsh-syntax-highlighting" ]]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$OMZ_CUSTOM/plugins/zsh-syntax-highlighting" &>> "$LOG_FILE"
    else
        log "zsh-syntax-highlighting already present; skipping."
    fi

    if [[ "$SHELL" != "/usr/bin/zsh" ]]; then
        log "Changing default shell to zsh..."
        chsh -s /usr/bin/zsh
    else
        log "Default shell already zsh."
    fi
}

switch_git_remote() {
    if git -C "$SCRIPT_DIR" rev-parse --is-inside-work-tree &>/dev/null; then
        current=$(git -C "$SCRIPT_DIR" remote get-url origin)
        if [[ "$current" =~ ^https ]]; then
            new="git@github.com:$(echo "$current" | sed -E 's#https://github.com/##')"
            git -C "$SCRIPT_DIR" remote set-url origin "$new"
            log "Switched remote to SSH: $new"
        else
            new="https://github.com/$(echo "$current" | sed -E 's#git@github.com:##')"
            git -C "$SCRIPT_DIR" remote set-url origin "$new"
            log "Switched remote to HTTPS: $new"
        fi
    else
        error "Not inside a git repository."
    fi
}

setup_groups_and_uinput() {
    groups=("scanner" "wheel" "audio" "input" "lp" "storage" "video" "fuse" "docker")
    read -p "Enter the username to add to groups: " username
    if ! id "$username" &>/dev/null; then
        error "User $username does not exist."
        return
    fi
    for group in "${groups[@]}"; do
        if ! getent group "$group" &>/dev/null; then
            sudo groupadd "$group"
            log "Group '$group' created."
        fi
        sudo usermod -aG "$group" "$username"
        log "User $username added to group '$group'."
    done
    echo 'KERNEL=="uinput", MODE="0660", GROUP="input"' | \
        sudo tee /etc/udev/rules.d/99-uinput.rules >/dev/null
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
        "Link configs/dotfiles") link_configs ;;
        "Setup Zsh + plugins") setup_zsh ;;
        "Switch Git remote (HTTPS <-> SSH)") switch_git_remote ;;
        "Setup user groups + uinput") setup_groups_and_uinput ;;
        "Quit") log "Goodbye!"; break ;;
        *) error "Invalid choice";;
    esac
done

log "All done. Backups (if any) are in $BACKUP_DIR. Errors (if any) are in $LOG_FILE"

