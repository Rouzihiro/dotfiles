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
log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }
log_step() { echo -e "${BLUE}[STEP]${NC} $1"; }
log_success() { echo -e "${CYAN}[SUCCESS]${NC} $1"; }
log_prompt() { echo -e "${MAGENTA}[PROMPT]${NC} $1"; }

# Remove comments/empty lines from package files
clean_package_list() {
    grep -v '^#' "install/$1" | grep -v '^$'
}

# Install packages from specified file
install_packages_from_file() {
    local file="$1"
    if [ ! -f "install/$file" ]; then
        log_warning "Package file not found: $file"
        return 1
    fi

    local packages
    mapfile -t packages < <(clean_package_list "$file")
    
    if [ ${#packages[@]} -eq 0 ]; then
        log_info "No packages to install from $file"
        return
    fi

    log_step "Installing packages from $file"
    case "$PM" in
        dnf)
            sudo dnf install -y "${packages[@]}" || {
                log_warning "Some packages failed to install from $file"
                return 1
            }
            ;;
        pacman)
            sudo pacman -S --noconfirm "${packages[@]}" || {
                log_warning "Some packages failed to install from $file"
                return 1
            }
            ;;
    esac
}

# Arch Linux profile selection
select_arch_packages() {
    echo -e "\n${CYAN}Select Arch Linux profile:${NC}"
    PS3='Choose an option: '
    options=(
        "Desktop (base + GUI)"
        "Server (base + server)"
        "Minimal (base only)"
        "Custom selection"
    )
    
    select opt in "${options[@]}"; do
        case $REPLY in
            1) PKG_FILES=("arch-base" "arch-desktop") ;;
            2) PKG_FILES=("arch-base" "arch-server") ;;
            3) PKG_FILES=("arch-base") ;;
            4)
                echo -e "\n${YELLOW}Available package files:${NC}"
                ls -1 install/arch-* 2>/dev/null | grep -v 'arch-aur' | sed 's|install/||'
                echo
                while true; do
                    read -p "Enter file names (space-separated): " -a PKG_FILES
                    # Validate input
                    invalid_files=()
                    for file in "${PKG_FILES[@]}"; do
                        [[ "$file" != arch-* ]] && invalid_files+=("$file")
                        [ ! -f "install/$file" ] && invalid_files+=("$file")
                    done
                    
                    if [ ${#invalid_files[@]} -eq 0 ]; then
                        break
                    else
                        echo -e "${RED}Invalid/missing files: ${invalid_files[*]}${NC}"
                        echo -e "${YELLOW}Files must start with 'arch-' and exist in install/${NC}"
                    fi
                done
                ;;
            *) 
                echo "Invalid option, try again"
                continue
                ;;
        esac
        break
    done
}

# Distro-specific installation logic
install_distro_packages() {
    case "$DISTRO" in
        fedora)
            install_packages_from_file "fedora-pkgs"
            # Enable COPR repos if file exists
            if [ -f "install/fedora-copr" ]; then
                log_step "Enabling COPR repositories"
                while read -r repo; do
                    [[ "$repo" =~ ^# ]] && continue
                    sudo dnf copr enable -y "$repo" || log_warning "Failed to enable COPR: $repo"
                done < <(clean_package_list "fedora-copr")
            fi
            ;;
        arch)
            select_arch_packages
            for file in "${PKG_FILES[@]}"; do
                install_packages_from_file "$file"
            done
            
            # Install AUR packages if yay exists
            if [ -f "install/arch-aur" ]; then
                if command -v yay >/dev/null; then
                    log_step "Installing AUR packages"
                    yay -S --noconfirm $(clean_package_list "arch-aur")
                else
                    log_warning "yay not found - skipping AUR packages"
                fi
            fi
            ;;
    esac
}

# Detect distribution
detect_distro() {
    if [ -f /etc/fedora-release ]; then
        DISTRO="fedora"
        PM="dnf"
    elif [ -f /etc/arch-release ]; then
        DISTRO="arch"
        PM="pacman"
    else
        log_error "Unsupported distribution. Only Fedora and Arch Linux are supported."
        exit 1
    fi
    log_info "Detected OS: ${GREEN}$DISTRO${NC} | Package manager: ${GREEN}$PM${NC}"
}

# Main installer flow
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
    
    # Confirm before proceeding
    read -p "Continue with installation? (y/N): " confirm
    [[ "$confirm" =~ ^[Yy]$ ]] || exit 0
    
    # Start installation
    install_distro_packages
    
    # Final message
    echo
    log_success "Installation complete!"
    echo -e "${YELLOW}You may need to reboot for all changes to take effect.${NC}"
}

main "$@"
