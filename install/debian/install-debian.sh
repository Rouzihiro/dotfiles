#!/bin/bash
# =====================================================
# Debian Setup Script (Dotfiles Installer)
# Compatible with Debian/Ubuntu/Raspbian derivatives
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
# Ensure apt package index is fresh
# (apt, unlike dnf, doesn't auto-refresh metadata on install)
# -------------------------------
sudo apt-get update 2>&1 | tee -a "$LOG_FILE"

# -------------------------------
# Ensure fzf installed
# -------------------------------
if ! command -v fzf &>/dev/null; then
		log "fzf not found, installing..."
		sudo apt-get install -y fzf 2>&1 | tee -a "$LOG_FILE"
fi

# -------------------------------
# Ensure zsh installed (needed for install.zsh)
# -------------------------------
if ! command -v zsh &>/dev/null; then
		log "zsh not found, installing..."
		sudo apt-get install -y zsh 2>&1 | tee -a "$LOG_FILE"
fi

# -------------------------------
# Functions
# -------------------------------
update_system() {
		log "Updating system..."
		sudo apt-get update 2>&1 | tee -a "$LOG_FILE"
		sudo apt-get upgrade -y 2>&1 | tee -a "$LOG_FILE"
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
		if ! sudo apt-get install -y "${PACKAGES[@]}" 2>&1 | tee -a "$LOG_FILE"; then
				error "Some packages failed to install."
		fi
}

# -------------------------------
# Debian has no COPR equivalent. Third-party repos are added as
# raw "deb ..." source-list entries instead of enabled by name.
#
# Expected format for pkgs/repos.txt, one repo per line, pipe-separated:
#   <deb-line>|<optional-gpg-key-url>|<optional-keyring-filename>
#
# Example:
#   deb [signed-by=/usr/share/keyrings/example.gpg] https://example.com/debian stable main|https://example.com/key.gpg|example.gpg
# -------------------------------
enable_third_party_repos() {
		local repo_file="$PKGS_DIR/repos.txt"
		[[ ! -f "$repo_file" ]] && { log "No repos.txt found, skipping third-party repos."; return; }

		log "Enabling third-party APT repos..."
		while IFS='|' read -r deb_line key_url keyring_name || [[ -n "$deb_line" ]]; do
				[[ -z "$deb_line" || "$deb_line" =~ ^[[:space:]]*# ]] && continue

		if [[ -n "$key_url" ]]; then
    if [[ -z "$keyring_name" ]]; then
        keyring_name="$(echo "$deb_line" | md5sum | cut -d' ' -f1).gpg"
    fi

    log "Fetching GPG key for repo: $key_url"
    curl -fsSL "$key_url" | sudo gpg --dearmor -o "/usr/share/keyrings/$keyring_name"
fi

				local list_name="$(echo "$deb_line" | md5sum | cut -d' ' -f1).list"
				log "Adding repo: $deb_line"
				echo "$deb_line" | sudo tee "/etc/apt/sources.list.d/$list_name" >/dev/null
		done < "$repo_file"

		log "Refreshing package index after adding repos..."
		sudo apt-get update 2>&1 | tee -a "$LOG_FILE"
}

# Packages that only exist via the third-party repos above.
# List them in pkgs/repo-packages.txt, one per line.
install_third_party_packages() {
		local pkg_file="$PKGS_DIR/repo-packages.txt"
		[[ ! -f "$pkg_file" ]] && { log "No repo-packages.txt found, skipping third-party packages."; return; }

		log "Installing packages from third-party repos..."
		while IFS= read -r pkg || [[ -n "$pkg" ]]; do
				[[ -z "$pkg" || "$pkg" =~ ^[[:space:]]*# ]] && continue
				log "Installing package: $pkg"
				sudo apt-get install -y "$pkg" 2>&1 | tee -a "$LOG_FILE"
		done < "$pkg_file"
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

install_broot() {
		# NOTE: Fedora's "libxcb" meta-package doesn't map 1:1 onto Debian.
		# libxcb1-dev is the closest analog for the clipboard feature's build
		# requirements, but confirm this against your actual Debian/Ubuntu
		# release (package names have shifted across recent versions).
		log "Installing broot dependencies (libxcb1-dev)..."
		sudo apt-get install -y libxcb1-dev 2>&1 | tee -a "$LOG_FILE"

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
		"Enable third-party repos"
		"Install third-party packages"
		"Install broot"
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
				"Enable third-party repos") enable_third_party_repos ;;
				"Install third-party packages") install_third_party_packages ;;
				"Install broot") install_broot ;;
				"Link configs/dotfiles") link_configs ;;
				"Setup Zsh + plugins") setup_zsh ;;
				"Switch Git remote (HTTPS <-> SSH)") switch_git_remote ;;
				"Setup user groups + uinput") setup_groups_and_uinput ;;
				"Quit") log "Goodbye!"; break ;;
				*) error "Invalid choice";;
		esac
done

log "All done. Backups (if any) are in $BACKUP_DIR. Errors (if any) are in $LOG_FILE"
