#!/bin/bash

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

# Logging
log_info()     { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warning()  { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error()    { echo -e "${RED}[ERROR]${NC} $1"; }
log_step()     { echo -e "${BLUE}[STEP]${NC} $1"; }
log_success()  { echo -e "${CYAN}[SUCCESS]${NC} $1"; }
log_prompt()   { echo -e "${MAGENTA}[PROMPT]${NC} $1"; }

# Package file cleaning
clean_package_list() {
    grep -vE '^\s*#|^\s*$' "install/$1"
}

# Install from package list
install_packages_from_file() {
    local file="$1"
    local path="install/$file"
    [[ ! -f "$path" ]] && log_warning "Missing file: $file" && return 1

    local packages
    mapfile -t packages < <(clean_package_list "$file")

    [[ ${#packages[@]} -eq 0 ]] && log_info "No packages in $file" && return

    log_step "Installing packages from $file"
    case "$PM" in
        dnf)    sudo dnf install -y "${packages[@]}" || log_warning "Some failed";;
        pacman) sudo pacman -S --noconfirm "${packages[@]}" || log_warning "Some failed";;
    esac
}

# Arch profiles
select_arch_packages() {
    echo -e "\n${CYAN}Select Arch Linux profile:${NC}"
    PS3='Choose an option: '
    options=("Desktop (base + GUI)" "Server (base + server)" "Minimal (base only)" "Custom selection")
    select opt in "${options[@]}"; do
        case $REPLY in
            1) PKG_FILES=("arch-base" "arch-desktop") ;;
            2) PKG_FILES=("arch-base" "arch-server") ;;
            3) PKG_FILES=("arch-base") ;;
            4)
                echo -e "\n${YELLOW}Available package files:${NC}"
                ls install/arch-* | grep -v 'aur' | sed 's|install/||'
                read -rp "Enter space-separated package file names: " -a PKG_FILES
                ;;
            *) echo "Invalid option"; continue ;;
        esac
        break
    done
}

# Fedora profiles
select_fedora_packages() {
    echo -e "\n${CYAN}Select Fedora profile:${NC}"
    PS3='Choose an option: '

    # Auto-detect files (excluding fedora-copr)
    local files=($(ls install/fedora-* 2>/dev/null | grep -v 'fedora-copr' | sed 's|install/||'))
    local options=("Default (fedora-pkgs)" "Custom selection")
    
    select opt in "${options[@]}"; do
        case $REPLY in
            1) PKG_FILES=("fedora-pkgs") ;;
            2)
                echo -e "\n${YELLOW}Available package files:${NC}"
                printf '%s\n' "${files[@]}"
                read -rp "Enter space-separated package file names: " -a PKG_FILES
                ;;
            *) echo "Invalid option"; continue ;;
        esac
        break
    done
}

# Install for Fedora
install_fedora() {
    select_fedora_packages
    for file in "${PKG_FILES[@]}"; do
        install_packages_from_file "$file"
    done

    # COPR
    if [[ -f install/fedora-copr ]]; then
        log_step "Enabling COPR repos..."
        while read -r repo; do
            [[ "$repo" =~ ^# ]] && continue
            sudo dnf copr enable -y "$repo" || log_warning "COPR failed: $repo"
        done < <(clean_package_list "fedora-copr")
    fi
}

# Install for Arch
install_arch() {
    select_arch_packages
    for file in "${PKG_FILES[@]}"; do
        install_packages_from_file "$file"
    done

    # AUR
    if [[ -f install/arch-aur && "$(command -v yay)" ]]; then
        log_step "Installing AUR packages..."
        yay -S --noconfirm $(clean_package_list "arch-aur")
    elif [[ -f install/arch-aur ]]; then
        log_warning "yay not found. Skipping AUR."
    fi
}

# Distro detection
detect_distro() {
    if [[ -f /etc/fedora-release ]]; then
        DISTRO="fedora"; PM="dnf"
    elif [[ -f /etc/arch-release ]]; then
        DISTRO="arch"; PM="pacman"
    else
        log_error "Unsupported distro. Only Fedora and Arch supported."
        exit 1
    fi
    log_info "Detected: ${GREEN}$DISTRO${NC} | Package manager: ${GREEN}$PM${NC}"
}

# Main
main() {
    clear
    echo -e "${GREEN}"
    cat << "EOF"
  ██████╗ ███████╗██╗   █╗██████╗  ██████╗ ████████╗███████╗
  ██╔══██╗██╔════╝╚██╗ ██╔╝██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝
  ██████╔╝█████╗   ╚████╔╝ ██║  ██║██║   ██║   ██║   ███████╗
  ██╔══██╗██╔══╝    ╚██╔╝  ██║  ██║██║   ██║   ██║   ╚════██║
  ██║  ██║███████╗   ██║   ██████╔╝╚██████╔╝   ██║   ███████║
  ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚═════╝  ╚═════╝    ╚═╝   ╚══════╝
EOF
    echo -e "${NC}"

    detect_distro

    read -rp "Continue with installation? (y/N): " confirm
    [[ "$confirm" =~ ^[Yy]$ ]] || exit 0

    case "$DISTRO" in
        fedora) install_fedora ;;
        arch)   install_arch ;;
    esac

    echo
    log_success "Installation complete!"
    echo -e "${YELLOW}You may need to reboot for all changes to take effect.${NC}"
}

main "$@"

