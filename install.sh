#!/bin/bash

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
    for file in $SELECTED; do
        while IFS= read -r pkg; do
            [[ "$pkg" =~ ^#.*$ || -z "$pkg" ]] && continue
            PACKAGES+=("$pkg")
        done < "$file"
    done

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
    log "Linking .config folders..."
    for folder in "$SCRIPT_DIR/.config/"*; do
        name=$(basename "$folder")
        target="$HOME/.config/$name"
        if [ -e "$target" ]; then
            mv "$target" "$BACKUP_DIR/"
            log "Backed up $target"
        fi
        ln -sf "$folder" "$target"
    done

    log "Linking .local/bin..."
    mkdir -p "$HOME/.local/bin"
    shopt -s nullglob
    for bin in "$SCRIPT_DIR/.local/bin/"*; do
        target="$HOME/.local/bin/$(basename "$bin")"
        [ -e "$target" ] && mv "$target" "$BACKUP_DIR/"
        ln -sf "$bin" "$target"
    done

    log "Linking .local/share/applications..."
    mkdir -p "$HOME/.local/share/applications"
    for f in "$SCRIPT_DIR/.local/share/applications/"*; do
        target="$HOME/.local/share/applications/$(basename "$f")"
        [ -e "$target" ] && mv "$target" "$BACKUP_DIR/"
        ln -sf "$f" "$target"
    done

    log "Linking .local/share/icons..."
    mkdir -p "$HOME/.local/share/icons"
    for f in "$SCRIPT_DIR/.local/share/icons/"*; do
        target="$HOME/.local/share/icons/$(basename "$f")"
        [ -e "$target" ] && mv "$target" "$BACKUP_DIR/"
        ln -sf "$f" "$target"
    done
    shopt -u nullglob
}

setup_zsh() {
    log "Copying .zshenv..."
    cp "$SCRIPT_DIR/.zshenv" "$HOME/.zshenv"

    log "Installing Oh My Zsh..."
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        git clone https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh" &>> "$LOG_FILE"
    fi

    log "Installing Oh My Zsh plugins..."
    OMZ_CUSTOM="$HOME/.oh-my-zsh/custom"
    git clone https://github.com/zsh-users/zsh-autosuggestions.git "$OMZ_CUSTOM/plugins/zsh-autosuggestions" &>> "$LOG_FILE"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$OMZ_CUSTOM/plugins/zsh-syntax-highlighting" &>> "$LOG_FILE"

    if [ "$SHELL" != "/usr/bin/zsh" ]; then
        log "Changing default shell to zsh..."
        chsh -s /usr/bin/zsh
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

log "All done. Errors (if any) are in $LOG_FILE"