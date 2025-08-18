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
# Update system
# -------------------------------
log "Updating system..."
sudo pacman -Syu --noconfirm &>> "$LOG_FILE"

# -------------------------------
# Package selection
# -------------------------------
if [[ ! -d "$PKGS_DIR" ]]; then
    error "Package directory '$PKGS_DIR' not found, aborting."
    exit 1
fi

log "Select package groups (TAB to multi-select, ENTER to confirm):"
SELECTED=$(find "$PKGS_DIR" -type f -print | fzf --multi --prompt="Select groups: " --ansi)
if [[ -z "$SELECTED" ]]; then
    log "No groups selected, aborting..."
    exit 0
fi

PACKAGES=()
for file in $SELECTED; do
    while IFS= read -r pkg; do
        [[ "$pkg" =~ ^#.*$ || -z "$pkg" ]] && continue
        PACKAGES+=("$pkg")
    done < "$file"
done

# -------------------------------
# Install packages via yay
# -------------------------------
log "Installing packages..."
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

# -------------------------------
# Backup and link .config
# -------------------------------
log "Linking .config folders..."
mkdir -p "$BACKUP_DIR"

for folder in "$SCRIPT_DIR/.config/"*; do
    name=$(basename "$folder")
    target="$HOME/.config/$name"
    if [ -e "$target" ]; then
        mv "$target" "$BACKUP_DIR/"
        log "Backed up $target"
    fi
    ln -sf "$folder" "$target"
done

# -------------------------------
# Link .local/bin
# -------------------------------
log "Linking .local/bin..."
mkdir -p "$HOME/.local/bin"
shopt -s nullglob
for bin in "$SCRIPT_DIR/.local/bin/"*; do
    target="$HOME/.local/bin/$(basename "$bin")"
    [ -e "$target" ] && mv "$target" "$BACKUP_DIR/"
    ln -sf "$bin" "$target"
done

# -------------------------------
# Link .local/share/applications and icons
# -------------------------------
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

# -------------------------------
# Copy .zshenv
# -------------------------------
log "Copying .zshenv..."
cp "$SCRIPT_DIR/.zshenv" "$HOME/.zshenv"

# -------------------------------
# Install Oh My Zsh + plugins
# -------------------------------
log "Installing Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    git clone https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh" &>> "$LOG_FILE"
fi

# Plugins
log "Installing Oh My Zsh plugins..."
OMZ_CUSTOM="$HOME/.oh-my-zsh/custom"
git clone https://github.com/zsh-users/zsh-autosuggestions.git "$OMZ_CUSTOM/plugins/zsh-autosuggestions" &>> "$LOG_FILE"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$OMZ_CUSTOM/plugins/zsh-syntax-highlighting" &>> "$LOG_FILE"

# -------------------------------
# Change default shell
# -------------------------------
if [ "$SHELL" != "/usr/bin/zsh" ]; then
    log "Changing default shell to zsh..."
    chsh -s /usr/bin/zsh
fi

log "Installation complete!"
log "Errors (if any) are in $LOG_FILE"
echo "Please log out and log back in for changes to take effect."

