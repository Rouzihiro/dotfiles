#!/bin/bash

# Color definitions
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Configuration Variables
PACKAGE_DIR="install"  # Directory containing package lists

# Package list directories
PACMAN_DIR="$PACKAGE_DIR/pacman"
AUR_DIR="$PACKAGE_DIR/aur"

# Initialize package arrays
PACMAN_PACKAGES=()
AUR_PACKAGES=()

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

# Function to read package files
read_package_files() {
    local dir="$1"
    local -n array_ref="$2"
    
    if [[ ! -d "$dir" ]]; then
        log_error "Package directory not found: $dir"
        return 1
    fi
    
    array_ref=()
    
    while IFS= read -r -d $'\0' file; do
        while IFS= read -r pkg; do
            [[ "$pkg" =~ ^#.*$ || -z "$pkg" ]] && continue
            array_ref+=("$pkg")
        done < "$file"
    done < <(find "$dir" -type f -print0)
}

# Function for text-based package selection
text_select_packages() {
    local dir="$1"
    local category="$2"
    local -n array_ref="$3"
    
    if [[ ! -d "$dir" ]]; then
        log_error "Package directory not found: $dir"
        return 1
    fi
    
    local groups=()
    local options=()
    
    # Build menu options
    while IFS= read -r -d $'\0' file; do
        local name=$(basename "$file")
        local desc=$(head -n1 "$file" | sed 's/# Description: //')
        groups+=("$name" "$desc")
    done < <(find "$dir" -type f -print0)
    
    if [[ ${#groups[@]} -eq 0 ]]; then
        log_warning "No package groups found in $dir"
        return 1
    fi
    
    echo -e "\n${CYAN}Available $category package groups:${NC}"
    for ((i=0; i<${#groups[@]}; i+=2)); do
        printf "%2d) %-20s %s\n" $((i/2+1)) "${groups[i]}" "${groups[i+1]}"
    done
    
    read -p "Select groups to install (space-separated numbers, 'all' for everything): " selections
    
    if [[ "$selections" == "all" ]]; then
        selections=$(seq 1 $((${#groups[@]}/2)) | tr '\n' ' ')
    fi
    
    array_ref=()
    for num in $selections; do
        if [[ $num -ge 1 && $num -le $((${#groups[@]}/2)) ]]; then
            idx=$(( (num-1)*2 ))
            local file="$dir/${groups[idx]}"
            
            if [[ -f "$file" ]]; then
                while IFS= read -r pkg; do
                    [[ "$pkg" =~ ^#.*$ || -z "$pkg" ]] && continue
                    array_ref+=("$pkg")
                done < "$file"
                log_info "Added package group: ${groups[idx]}"
            fi
        fi
    done
}

dialog_select_packages() {
    local dir="$1"
    local category="$2"
    local -n array_ref="$3"
    
    if [[ ! -d "$dir" ]]; then
        log_error "Package directory not found: $dir"
        return 1
    fi
    
    local options=()
    
    while IFS= read -r -d $'\0' file; do
        options+=("$(basename "$file")" "$(head -n1 "$file" | sed 's/# Description: //')" "off")
    done < <(find "$dir" -type f -print0)
    
    if [[ ${#options[@]} -eq 0 ]]; then
        log_warning "No package groups found in $dir"
        return 1
    fi
    
    local choices
    choices=$(dialog --stdout --title "Select $category Packages" \
        --checklist "Choose package groups to install:" \
        20 60 15 "${options[@]}")
    local dialog_exit=$?
    
    # Clear the screen after dialog closes
    clear
    
    if [ $dialog_exit -ne 0 ]; then
        return 1
    fi
    
    array_ref=()
    for choice in $choices; do
        choice=$(echo "$choice" | tr -d '"')
        local file="$dir/$choice"
        
        if [[ -f "$file" ]]; then
            while IFS= read -r pkg; do
                [[ "$pkg" =~ ^#.*$ || -z "$pkg" ]] && continue
                array_ref+=("$pkg")
            done < "$file"
            log_info "Added package group: $choice"
        fi
    done
}

# Function to select packages (auto-detects best method)
select_packages() {
    if command -v dialog &> /dev/null && [ -n "$DISPLAY" ]; then
        dialog_select_packages "$@"
    else
        text_select_packages "$@"
    fi
}

check_permissions() {
    if [[ $EUID -eq 0 ]]; then
        log_error "Do not run this script with sudo. Run as a normal user."
        exit 1
    fi
}

check_system() {
    if ! command -v pacman &> /dev/null; then
        log_error "This script is designed for Arch-based distributions only."
        exit 1
    fi
    log_info "System check passed. Continuing installation..."
}

update_system() {
    log_step "Updating system packages"
    sudo pacman -Syu --noconfirm || {
        log_warning "System update completed with some warnings. Continuing..."
    }
}

backup_configs() {
    while true; do
        read -p "Create backup of current configs? [y/n]: " backup_choice
        case "$backup_choice" in
            [yY]* )
                local backup_dir="$HOME/reydots_backup_$(date +%Y%m%d_%H%M%S)"
                log_step "Creating backup directory at $backup_dir"
                mkdir -p "$backup_dir"
                log_success "Backup directory created at $backup_dir"
                return 0
                ;;
            [nN]* )
                log_info "Skipping backup as requested."
                return 0
                ;;
            * ) echo "Please answer yes (y) or no (n)." ;;
        esac
    done
}

install_pacman_packages() {
    log_step "Installing packages from official repositories"
    
    local to_install=()
    for pkg in "${PACMAN_PACKAGES[@]}"; do
        if ! pacman -Q "$pkg" &> /dev/null; then
            to_install+=("$pkg")
        fi
    done
    
    if [ ${#to_install[@]} -eq 0 ]; then
        log_info "All official packages are already installed."
    else
        log_info "Installing ${#to_install[@]} packages..."
        sudo pacman -S --needed --noconfirm "${to_install[@]}" || {
            log_error "Failed to install some packages."
            read -p "Continue anyway? (y/n): " continue_choice
            [[ $continue_choice != [yY] ]] && exit 1
        }
    fi
}

install_yay() {
    log_step "Checking for AUR helper (yay)"
    
    if command -v yay &> /dev/null; then
        log_info "Yay is already installed."
        return 0
    fi
    
    log_info "Installing Yay AUR helper..."
    sudo pacman -S --needed --noconfirm git base-devel
    
    local temp_dir=$(mktemp -d)
    git clone https://aur.archlinux.org/yay.git "$temp_dir"
    cd "$temp_dir" || {
        log_error "Failed to navigate to temp directory."
        exit 1
    }
    
    makepkg -si --noconfirm || {
        log_error "Failed to install yay."
        exit 1
    }
    
    cd - > /dev/null
    rm -rf "$temp_dir"
    log_success "Yay installed successfully."
}

install_aur_packages() {
    log_step "Installing packages from AUR"
    
    local to_install=()
    for pkg in "${AUR_PACKAGES[@]}"; do
        if ! yay -Q "$pkg" &> /dev/null; then
            to_install+=("$pkg")
        fi
    done
    
    if [ ${#to_install[@]} -eq 0 ]; then
        log_info "All AUR packages are already installed."
    else
        log_info "Installing ${#to_install[@]} AUR packages..."
        yay -S --needed --noconfirm "${to_install[@]}" || {
            log_warning "Some AUR packages may have failed."
            read -p "Continue anyway? (y/n): " continue_choice
            [[ $continue_choice != [yY] ]] && exit 1
        }
    fi
}

install_omz() {
    log_step "Installing Oh My Zsh (no configs will be copied)"
    
    if ! command -v zsh &> /dev/null; then
        log_error "Zsh is not installed."
        exit 1
    fi
    
    if [ -d "$HOME/.oh-my-zsh" ]; then
        log_info "Oh My Zsh is already installed."
    else
        log_info "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi
    log_success "Oh My Zsh installed (no configs copied)."
}

configure_services() {
    log_step "Configuring system services"
    log_success "Services configured."
}

show_header() {
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
    echo -e "${CYAN}ReyDots Package Installer${NC}"
    echo -e "Modular package installation only (no dotfiles will be copied)"
    echo
}

main() {
    show_header
    check_permissions
    check_system
    
    read -p "Start package installation? (y/n): " confirm
    [[ $confirm != [yY] ]] && { log_info "Installation aborted."; exit 0; }
    
    update_system
    backup_configs
    
    # Package selection
    if [[ -d "$PACMAN_DIR" ]]; then
        select_packages "$PACMAN_DIR" "Pacman" PACMAN_PACKAGES
    else
        log_warning "Pacman package directory not found"
        read_package_files "$PACMAN_DIR" PACMAN_PACKAGES
    fi
    
    if [[ -d "$AUR_DIR" ]]; then
        select_packages "$AUR_DIR" "AUR" AUR_PACKAGES
    else
        log_warning "AUR package directory not found"
        read_package_files "$AUR_DIR" AUR_PACKAGES
    fi
    
    install_pacman_packages
    install_yay
    install_aur_packages
    install_omz
    configure_services
    
    echo
    log_success "Package installation complete!"
}

main
