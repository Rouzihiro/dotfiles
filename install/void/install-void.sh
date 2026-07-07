#!/bin/bash
# =====================================================
# Void Linux Setup Script (Dotfiles Installer)
# =====================================================

set -o pipefail

# -------------------------------
# Variables
# -------------------------------
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
DOTFILES_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
BACKUP_DIR="$HOME/.bkp_config_$(date +%Y%m%d_%H%M%S)"
LOG_FILE="$HOME/.logs/installer-log.txt"
PKGS_DIR="$SCRIPT_DIR/pkgs"

# Try sourcing from PATH first, then fall back to the shared root-level copy
if ! source Global_functions.sh 2>/dev/null; then
    if ! source "$DOTFILES_ROOT/Global_functions.sh"; then
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
    sudo xbps-install -Sy --yes fzf 2>&1 | tee -a "$LOG_FILE"
fi

# -------------------------------
# Ensure zsh installed (needed for install.zsh)
# -------------------------------
if ! command -v zsh &>/dev/null; then
    log "zsh not found, installing..."
    sudo xbps-install -Sy --yes zsh 2>&1 | tee -a "$LOG_FILE"
fi

# -------------------------------
# Helper: sanitize a raw line from a pkgs file into a clean package name
# Strips CRLF, inline comments, and leading/trailing whitespace.
# -------------------------------
sanitize_pkg_line() {
    local pkg="$1"
    pkg="${pkg%$'\r'}"          # strip trailing CR (CRLF files)
    pkg="${pkg%%#*}"            # strip inline comments
    pkg="${pkg#"${pkg%%[![:space:]]*}"}"  # trim leading whitespace
    pkg="${pkg%"${pkg##*[![:space:]]}"}"  # trim trailing whitespace
    printf '%s' "$pkg"
}

# -------------------------------
# Functions
# -------------------------------
update_system() {
    log "Syncing repo index and updating system..."
    sudo xbps-install -Su --yes 2>&1 | tee -a "$LOG_FILE"
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
        while IFS= read -r raw_line || [[ -n "$raw_line" ]]; do
            pkg=$(sanitize_pkg_line "$raw_line")
            [[ -z "$pkg" ]] && continue
            PACKAGES+=("$pkg")
        done < "$file"
    done <<< "$SELECTED"

    if [[ ${#PACKAGES[@]} -eq 0 ]]; then
        error "No valid package names resolved from selected files. Check for empty/comment-only files."
        return
    fi

    # De-duplicate while preserving order
    declare -A seen
    UNIQUE_PACKAGES=()
    for p in "${PACKAGES[@]}"; do
        [[ -n "${seen[$p]}" ]] && continue
        seen[$p]=1
        UNIQUE_PACKAGES+=("$p")
    done

    log "Resolved ${#UNIQUE_PACKAGES[@]} package(s): ${UNIQUE_PACKAGES[*]}"

    log "Installing selected packages..."
    if ! sudo xbps-install -Sy --yes "${UNIQUE_PACKAGES[@]}" 2>&1 | tee -a "$LOG_FILE"; then
        error "Some packages failed to install. Check names above against 'xbps-query -Rs <name>'."
    fi
}

copy_dotfiles_config() {
    local CONFIG_SRC="$DOTFILES_ROOT/config"

    if [[ ! -d "$CONFIG_SRC" ]]; then
        error "Config source directory '$CONFIG_SRC' not found."
        return
    fi

    log "Copying everything from $CONFIG_SRC into \$HOME (existing items will be backed up first)..."
    mkdir -p "$BACKUP_DIR"

    shopt -s dotglob nullglob
    for item in "$CONFIG_SRC"/*; do
        local name target
        name="$(basename "$item")"
        target="$HOME/$name"

        if [[ -e "$target" || -L "$target" ]]; then
            log "Backing up existing \$HOME/$name -> $BACKUP_DIR/$name"
            mv -f "$target" "$BACKUP_DIR/$name" 2>&1 | tee -a "$LOG_FILE"
        fi

        cp -a "$item" "$HOME/" 2>&1 | tee -a "$LOG_FILE"
        log "Copied $name -> \$HOME/$name"
    done
    shopt -u dotglob nullglob

    log "Copy complete. Backups (if any) are in $BACKUP_DIR"
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
    groups=("wheel" "audio" "input" "lp" "storage" "video" "fuse" "docker" "cdrom")
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
# void-packages (xbps-src) build environment
# Void's closest equivalent to the AUR: a git repo of build
# templates you compile locally with xbps-src, rather than a
# helper that fetches prebuilt binaries.
# -------------------------------
setup_void_packages() {
    local VOID_PACKAGES_DIR="${HOME}/void-packages"

    if [[ -d "$VOID_PACKAGES_DIR" ]]; then
        log "void-packages already cloned at $VOID_PACKAGES_DIR. Updating..."
        (cd "$VOID_PACKAGES_DIR" && git pull) 2>&1 | tee -a "$LOG_FILE"
    else
        log "Cloning void-packages..."
        git clone https://github.com/void-linux/void-packages.git "$VOID_PACKAGES_DIR" 2>&1 | tee -a "$LOG_FILE"
    fi

    log "Installing xbps-src build dependencies..."
    sudo xbps-install -Sy --yes base-devel 2>&1 | tee -a "$LOG_FILE"

    log "Bootstrapping xbps-src (masterdir)..."
    (cd "$VOID_PACKAGES_DIR" && ./xbps-src binary-bootstrap) 2>&1 | tee -a "$LOG_FILE"

    log "void-packages ready. Build a template with:"
    log "  cd $VOID_PACKAGES_DIR && ./xbps-src pkg <template-name>"
    log "Then install the resulting binary with:"
    log "  sudo xbps-install --repository=$VOID_PACKAGES_DIR/hostdir/binpkgs <template-name>"
}

remove_void_packages() {
    local VOID_PACKAGES_DIR="${HOME}/void-packages"

    if [[ ! -d "$VOID_PACKAGES_DIR" ]]; then
        log "void-packages is not present at $VOID_PACKAGES_DIR."
        return
    fi

    read -p "Remove void-packages checkout at $VOID_PACKAGES_DIR? (y/N): " answer
    [[ ! "$answer" =~ ^[Yy]$ ]] && { log "Cancelled."; return; }

    rm -rf "$VOID_PACKAGES_DIR"
    log "void-packages removed."
}

# -------------------------------
# Menu
# -------------------------------
OPTIONS=(
    "Update system"
    "Install packages"
    "Copy .config and system files"
    "Setup Zsh + plugins"
    "Switch Git remote (HTTPS <-> SSH)"
    "Setup user groups + uinput"
    "Setup void-packages (xbps-src build env)"
    "Remove void-packages checkout"
    "Quit"
)

while true; do
    CHOICE=$(printf '%s\n' "${OPTIONS[@]}" | fzf --prompt="Select task: " --height=15 --reverse)
    case $CHOICE in
        "Update system") update_system ;;
        "Install packages") install_packages ;;
        "Copy .config and system files") copy_dotfiles_config ;;
        "Setup Zsh + plugins") setup_zsh ;;
        "Switch Git remote (HTTPS <-> SSH)") switch_git_remote ;;
        "Setup user groups + uinput") setup_groups_and_uinput ;;
        "Setup void-packages (xbps-src build env)") setup_void_packages ;;
        "Remove void-packages checkout") remove_void_packages ;;
        "Quit") log "Goodbye!"; break ;;
        *) error "Invalid choice";;
    esac
done

log "All done. Backups (if any) are in $BACKUP_DIR. Errors (if any) are in $LOG_FILE"
