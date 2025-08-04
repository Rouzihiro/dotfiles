#!/bin/bash

# Color definitions
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

# Logging functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_step() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

log_success() {
    echo -e "${CYAN}[SUCCESS]${NC} $1"
}

log_prompt() {
    echo -e "${MAGENTA}[PROMPT]${NC} $1"
}

# Clean package list (remove comments/empty lines)
clean_package_list() {
    grep -v '^#' "$1" | grep -v '^$'
}

# Install packages from file
install_packages() {
    local pkg_file="$1"
    local packages=()
    
    mapfile -t packages < <(clean_package_list "$pkg_file")
    
    if [ ${#packages[@]} -eq 0 ]; then
        log_info "No packages to install from $pkg_file"
        return
    fi

    log_step "Installing packages from $pkg_file"
    case "$PM" in
        dnf)
            sudo dnf install -y "${packages[@]}" || {
                log_warning "Some packages failed to install"
                return 1
            }
            ;;
        pacman)
            sudo pacman -S --noconfirm "${packages[@]}" || {
                log_warning "Some packages failed to install"
                return 1
            }
            ;;
    esac
}

# Main installer logic
main() {
    # Detect distro first
    if [ -f /etc/fedora-release ]; then
        DISTRO="fedora"
        PM="dnf"
    elif [ -f /etc/arch-release ]; then
        DISTRO="arch"
        PM="pacman"
    else
        log_error "Unsupported distribution"
        exit 1
    fi
    log_info "Detected OS: $DISTRO | Package manager: $PM"

    # Install packages
    install_packages "install/${DISTRO}-pkgs"

    # Handle distro-specific extras
    case "$DISTRO" in
        fedora)
            # Enable COPR repos
            if [ -f "install/fedora-copr" ]; then
                log_step "Enabling COPR repositories"
                while read -r repo; do
                    [[ "$repo" =~ ^# ]] && continue  # Skip comments
                    sudo dnf copr enable -y "$repo" || log_warning "Failed to enable COPR: $repo"
                done < "install/fedora-copr"
            fi
            ;;
        arch)
            # Install AUR helper if yay doesn't exist
            if ! command -v yay &> /dev/null && [ -f "install/arch-aur" ]; then
                prompt_user "Install yay (AUR helper)?" \
                    "sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si --noconfirm && cd .. && rm -rf yay"
            fi
            
            # Install AUR packages
            if command -v yay &> /dev/null && [ -f "install/arch-aur" ]; then
                log_step "Installing AUR packages"
                yay -S --noconfirm $(clean_package_list "install/arch-aur")
            fi
            ;;
    esac

    log_success "Installation complete!"
}

main "$@"
