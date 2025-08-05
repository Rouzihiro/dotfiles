#!/usr/bin/env bash

set -euo pipefail

# Color constants
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_step() { echo -e "${CYAN}==> $1${NC}"; }
log_info() { echo -e "${CYAN}[INFO] $1${NC}"; }
log_success() { echo -e "${GREEN}[OK] $1${NC}"; }
log_warning() { echo -e "${YELLOW}[WARN] $1${NC}"; }
log_error() { echo -e "${RED}[ERROR] $1${NC}"; }

install_packages_from_file() {
    local file="$1"
    local path="install/$file"

    [[ ! -f "$path" ]] && { log_warning "Missing file: $file"; return 1; }

    log_step "Installing packages from $file..."
    grep -vE '^\s*#|^\s*$' "$path" | xargs sudo dnf install -y
}

install_arch_packages_from_file() {
    local file="$1"
    local path="install/$file"

    [[ ! -f "$path" ]] && { log_warning "Missing file: $file"; return 1; }

    log_step "Installing packages from $file..."
    grep -vE '^\s*#|^\s*$' "$path" | xargs sudo pacman -S --noconfirm --needed
}

clean_package_list() {
    grep -vE '^\s*#|^\s*$' "install/$1"
}

main() {
    log_step "Starting system setup..."

    if grep -qi fedora /etc/os-release; then
        log_info "Detected Fedora system"

        PKG_FILES=("fedora-base" "fedora-desktop" "fedora-flatpak" "fedora-fonts" "fedora-themes")

        for file in "${PKG_FILES[@]}"; do
            install_packages_from_file "$file"
        done

    elif grep -qi arch /etc/os-release; then
        log_info "Detected Arch system"

        PKG_FILES=("arch-base" "arch-fonts" "arch-themes" "arch-desktop")

        for file in "${PKG_FILES[@]}"; do
            install_arch_packages_from_file "$file"
        done

        if ! command -v yay &>/dev/null; then
            log_info "Installing yay AUR helper..."
            git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
            pushd /tmp/yay-bin >/dev/null
            makepkg -si --noconfirm
            popd >/dev/null
        fi

        # Handle AUR packages
        aur_files=()
        if compgen -G "install/arch-aur-*" > /dev/null; then
            aur_files=($(ls install/arch-aur-* 2>/dev/null | sed 's|install/||'))
        fi

        if [[ ${#aur_files[@]} -eq 0 ]]; then
            log_info "No AUR package files found in install/ directory."
        else
            echo -e "\nAvailable AUR package lists:"
            for file in "${aur_files[@]}"; do
                echo "  - $file"
            done

            echo -en "\nEnter space-separated AUR files to install (or press enter to skip): "
            read -ra SELECTED_AUR_FILES

            for aur_file in "${SELECTED_AUR_FILES[@]}"; do
                if [[ ! -f "install/$aur_file" ]]; then
                    log_warning "File not found: $aur_file"
                    continue
                fi

                mapfile -t aur_pkgs < <(clean_package_list "$aur_file")
                if [[ ${#aur_pkgs[@]} -gt 0 ]]; then
                    yay -S --noconfirm "${aur_pkgs[@]}" || log_warning "Failed installing from $aur_file"
                fi
            done
        fi

    else
        log_error "Unsupported distribution. Only Fedora and Arch are supported."
        exit 1
    fi

    log_success "System setup complete."
}

main "$@"

