#!/bin/bash
# =====================================================
# Fedora ARM Setup Script (Dotfiles Installer)
# Compatible with Fedora Workstation/Asahi/ARM
# =====================================================

set -o pipefail

# -------------------------------
# Variables
# -------------------------------
SCRIPT_DIR=$(pwd)
BACKUP_DIR="$HOME/.bkp_config_$(date +%Y%m%d_%H%M%S)"
LOG_FILE="$HOME/Documents/installer-log.txt"
PKGS_DIR="$SCRIPT_DIR/pkgs/fedora"

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
    sudo dnf install -y fzf &>> "$LOG_FILE"
fi

# -------------------------------
# Safe symlink helper
# -------------------------------
backup_and_link() {
    local source="$1"
    local target="$2"

    mkdir -p "$(dirname "$target")"

    if [[ ! -e "$source" && ! -L "$source" ]]; then
        error "Source $source does not exist; skipping."
        return
    fi

    if [[ -L "$target" ]]; then
        local target_resolved source_resolved
        target_resolved="$(readlink -f "$target" 2>/dev/null || true)"
        source_resolved="$(readlink -f "$source" 2>/dev/null || true)"
        if [[ "$target_resolved" == "$source_resolved" ]]; then
            log "$target already points to $source; skipping."
            return
        fi
        log "Backing up existing symlink $target -> $BACKUP_DIR/"
        mv "$target" "$BACKUP_DIR/"
    elif [[ -e "$target" ]]; then
        log "Backing up existing file/dir $target -> $BACKUP_DIR/"
        mv "$target" "$BACKUP_DIR/"
    fi

    log "Linking $source -> $target"
    ln -s "$source" "$target"
}

# -------------------------------
# Functions
# -------------------------------

update_system() {
    log "Updating system..."
    sudo dnf upgrade -y &>> "$LOG_FILE"
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
            [[ "$pkg" =~ ^#.*$ || -z "$pkg" ]] && continue
            PACKAGES+=("$pkg")
        done < "$file"
    done <<< "$SELECTED"

    log "Installing selected packages..."
    sudo dnf install -y "${PACKAGES[@]}" &>> "$LOG_FILE" || error "Some packages failed to install."
}

link_configs() {
    log "Linking .config directories..."
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

    log "Linking .local/bin..."
    backup_and_link "$SCRIPT_DIR/.local/bin" "$HOME/.local/bin"

    log "Linking .Xresources, .xinitrc, .zshenv..."
    backup_and_link "$SCRIPT_DIR/.Xresources.d" "$HOME/.Xresources.d"
    backup_and_link "$SCRIPT_DIR/.Xresources" "$HOME/.Xresources"
    backup_and_link "$SCRIPT_DIR/.xinitrc" "$HOME/.xinitrc"
    backup_and_link "$SCRIPT_DIR/.zshenv" "$HOME/.zshenv"

    log "Linking .local/share/applications..."
    backup_and_link "$SCRIPT_DIR/.local/share/applications" "$HOME/.local/share/applications"

    log "Linking .local/share/icons..."
    backup_and_link "$SCRIPT_DIR/.local/share/icons" "$HOME/.local/share/icons"
}

setup_zsh() {
    log "Installing Oh My Zsh..."
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        git clone https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh" &>> "$LOG_FILE"
    else
        log "Oh My Zsh already present; skipping."
    fi

    log "Installing Oh My Zsh plugins..."
    OMZ_CUSTOM="$HOME/.oh-my-zsh/custom"
    mkdir -p "$OMZ_CUSTOM/plugins"
    if [[ ! -d "$OMZ_CUSTOM/plugins/zsh-autosuggestions" ]]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions.git "$OMZ_CUSTOM/plugins/zsh-autosuggestions" &>> "$LOG_FILE"
    fi
    if [[ ! -d "$OMZ_CUSTOM/plugins/zsh-syntax-highlighting" ]]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$OMZ_CUSTOM/plugins/zsh-syntax-highlighting" &>> "$LOG_FILE"
    fi

    if [[ "$SHELL" != "/bin/zsh" ]]; then
        log "Changing default shell to zsh..."
        chsh -s /bin/zsh
    else
        log "Default shell already zsh."
    fi
}

switch_git_remote() {
    if git -C "$SCRIPT_DIR" rev-parse --is-inside-work-tree &>/dev/null; then
        current=$(git -C "$SCRIPT_DIR" remote get-url origin)
        if [[ "$current" =~ ^https://github.com/ ]]; then
            user_repo=$(echo "$current" | sed -E 's#https://github.com/(.+)#\1#')
            new="git@github.com:$user_repo"
            git -C "$SCRIPT_DIR" remote set-url origin "$new"
            log "Switched remote to SSH: $new"
        else
            log "Remote already using SSH: $current"
        fi
    else
        error "Not inside a git repository at $SCRIPT_DIR."
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
