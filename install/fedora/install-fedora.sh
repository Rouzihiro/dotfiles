#!/bin/bash
# =====================================================
# Fedora Setup Script (Dotfiles Installer)
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
# Helper: sanitize a raw line from a pkgs/copr file into a clean value.
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
    if ! sudo dnf install -y "${UNIQUE_PACKAGES[@]}" 2>&1 | tee -a "$LOG_FILE"; then
        error "Some packages failed to install. Check names above against 'dnf search <name>'."
    fi
}

enable_copr_repos() {
    local copr_file="$PKGS_DIR/copr.txt"
    [[ ! -f "$copr_file" ]] && { log "No copr.txt found, skipping COPR repos."; return; }

    log "Enabling COPR repos..."
    while IFS= read -r raw_line || [[ -n "$raw_line" ]]; do
        repo=$(sanitize_pkg_line "$raw_line")
        [[ -z "$repo" ]] && continue
        log "Enabling COPR repo: $repo"
        sudo dnf copr enable -y "$repo" 2>&1 | tee -a "$LOG_FILE"
    done < "$copr_file"
}

install_copr_packages() {
    local copr_file="$PKGS_DIR/copr.txt"
    [[ ! -f "$copr_file" ]] && { log "No copr.txt found, skipping COPR packages."; return; }

    log "Installing packages from COPR..."
    while IFS= read -r raw_line || [[ -n "$raw_line" ]]; do
        repo=$(sanitize_pkg_line "$raw_line")
        [[ -z "$repo" ]] && continue
        log "Enabling COPR repo: $repo"
        sudo dnf copr enable -y "$repo" 2>&1 | tee -a "$LOG_FILE"

        pkg=$(basename "$repo")
        log "Installing package from COPR: $pkg"
        sudo dnf install -y "$pkg" 2>&1 | tee -a "$LOG_FILE"
    done < "$copr_file"
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

install_broot() {
    log "Installing broot dependencies (libxcb)..."
    sudo dnf install -y libxcb 2>&1 | tee -a "$LOG_FILE"

    if ! command -v cargo &>/dev/null; then
        error "cargo not found. Install Rust (e.g. via rustup) before installing broot."
        return
    fi

    log "Installing broot via cargo (with clipboard feature)..."
    if ! cargo install --locked --features clipboard broot 2>&1 | tee -a "$LOG_FILE"; then
        error "broot installation failed."
        return
    fi

    log "broot installed successfully!"
}

# -------------------------------
# Menu
# -------------------------------
OPTIONS=(
    "Update system"
    "Install packages"
    "Enable COPR repos"
    "Install COPR packages"
    "Install broot"
    "Copy .config and system files"
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
        "Install broot") install_broot ;;
        "Copy .config and system files") copy_dotfiles_config ;;
        "Setup Zsh + plugins") setup_zsh ;;
        "Switch Git remote (HTTPS <-> SSH)") switch_git_remote ;;
        "Setup user groups + uinput") setup_groups_and_uinput ;;
        "Quit") log "Goodbye!"; break ;;
        *) error "Invalid choice";;
    esac
done

log "All done. Backups (if any) are in $BACKUP_DIR. Errors (if any) are in $LOG_FILE"
