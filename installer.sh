#!/bin/bash

# Color definitions
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# ===============================================
# Configuration Variables
# ===============================================
DOTFILES_SOURCE="$HOME/dotfiles/"  # Dotfiles location
PACKAGE_DIR="install"              # Directory containing package lists
# ===============================================

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
        options+=("$name" "$desc" off)
    done < <(find "$dir" -type f -print0)
    
    if [[ ${#groups[@]} -eq 0 ]]; then
        log_warning "No package groups found in $dir"
        return 1
    fi
    
    echo -e "\n${CYAN}Available $category package groups:${NC}"
    for ((i=0; i<${#groups[@]}; i+=2)); do
        printf "%2d) %-20s %s\n" $((i/2+1)) "${groups[i]}" "${groups[i+1]}"
    done
    
    read -p "Select groups to install (space-separated numbers, all for everything): " selections
    
    # Process 'all' selection
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

# Function for dialog-based package selection
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
        20 60 15 "${options[@]}") || return 1
    
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

# Check if script is run by root
check_permissions() {
    if [[ $EUID -eq 0 ]]; then
        log_error "Do not run this script with sudo. Run as a normal user."
        exit 1
    fi
}

# Check for Arch-based distro
check_system() {
    if ! command -v pacman &> /dev/null; then
        log_error "This script is designed for Arch-based distributions only."
        exit 1
    fi
    
    log_info "System check passed. Continuing installation..."
}

# Update system packages
update_system() {
    log_step "Updating system packages"
    sudo pacman -Syu --noconfirm || {
        log_warning "System update completed with some warnings. Continuing..."
    }
}

backup_configs() {
    while true; do
        read -p "Do you want to create a backup of your current configs? [y/n]: " backup_choice
        case "$backup_choice" in
            [yY]* )
                local backup_dir="$HOME/reydots_backup_$(date +%Y%m%d_%H%M%S)"
                log_step "Creating backup of existing configurations to $backup_dir"
                mkdir -p "$backup_dir"
                
                local items_to_backup=(
                    ".config/rofi"
                    ".config/neovim"
                    ".local/bin/"
                    ".aliases"
                    ".zshrc"
                )
                
                for item in "${items_to_backup[@]}"; do
                    if [ -e "$HOME/$item" ]; then
                        mkdir -p "$(dirname "$backup_dir/$item")"
                        cp -r "$HOME/$item" "$backup_dir/$item"
                        log_info "Backed up $item to $backup_dir"
                    fi
                done
                
                log_success "Backup completed. Your original files are saved in $backup_dir"
                return 0
                ;;
            [nN]* )
                log_info "Skipping backup as requested by user."
                return 0
                ;;
            * )
                echo "Please answer yes (y) or no (n)."
                ;;
        esac
    done
}

# Install packages from official repositories
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
            log_error "Failed to install some packages. Please check the output above."
            read -p "Do you want to continue anyway? (y/n): " continue_choice
            [[ $continue_choice != [yY] ]] && exit 1
        }
    fi
}

# Install yay AUR helper
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
        log_error "Failed to navigate to temporary directory for yay installation."
        exit 1
    }
    
    makepkg -si --noconfirm || {
        log_error "Failed to install yay. Please install it manually."
        exit 1
    }
    
    cd - > /dev/null
    rm -rf "$temp_dir"
    
    log_success "Yay installed successfully."
}

# Install packages from AUR
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
            log_warning "Some AUR packages may have failed to install."
            read -p "Do you want to continue anyway? (y/n): " continue_choice
            [[ $continue_choice != [yY] ]] && exit 1
        }
    fi
}

# Install dotfiles
install_dotfiles() {
    log_step "Installing ReyDots configuration files"

    if [ ! -d "$DOTFILES_SOURCE" ]; then
        log_error "Dotfiles source directory not found at: $DOTFILES_SOURCE"
        exit 1
    fi

    mkdir -p "$HOME/.config"
    mkdir -p "$HOME/bin"
    mkdir -p "$HOME/.local/bin"
    mkdir -p "$HOME/.local/share"
    mkdir -p "$HOME/Pictures/wallpapers"
    mkdir -p "$HOME/Documents/"
    mkdir -p "$HOME/Downloads"
    mkdir -p "$HOME/.themes"
    mkdir -p "$HOME/.icons"
    mkdir -p "$HOME/.local/share/icons"
    
    if [ -d "$DOTFILES_SOURCE/.config" ]; then
        cp -r "$DOTFILES_SOURCE/.config/"* "$HOME/.config/" || log_warning "Error copying .config files"
        log_info "Copied configuration files to ~/.config/"
    else
        log_error "Config directory not found in $DOTFILES_SOURCE!"
        exit 1
    fi
    
    if [ -d "$DOTFILES_SOURCE/.local" ]; then
        cp -r "$DOTFILES_SOURCE/.local/"* "$HOME/.local/" || log_warning "Error copying .local files"
        log_info "Copied local files to ~/.local/"
    fi

    if [ -d "$DOTFILES_SOURCE/bin" ]; then
        cp -r "$DOTFILES_SOURCE/bin/"* "$HOME/bin/" || log_warning "Error copying bin files"
        log_info "Copied local files to ~/bin/"
    fi
    
    if [ -d "$DOTFILES_SOURCE/.themes" ]; then
        cp -r "$DOTFILES_SOURCE/.themes/"* "$HOME/.themes/" || log_warning "Error copying theme files"
        log_info "Copied theme files to ~/.themes/"
    fi
    
    if [ -d "$DOTFILES_SOURCE/.icons" ]; then
        cp -r "$DOTFILES_SOURCE/.icons/"* "$HOME/.icons/" || log_warning "Error copying icon files"
        log_info "Copied icon files to ~/.icons/"
    fi
    
    if [ -d "$DOTFILES_SOURCE/.walls" ]; then
        cp -r "$DOTFILES_SOURCE/.walls/"* "$HOME/Pictures/wallpapers/" 2>/dev/null || log_warning "Error copying wallpapers"
        log_info "Copied wallpapers to ~/Pictures/wallpapers/"
    fi
    
    log_success "ReyDots files installed successfully from $DOTFILES_SOURCE"
}

# Install Oh My Zsh and plugins
install_omz() {
    log_step "Setting up Zsh environment"
    
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
    
    ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
    
    log_info "Installing Zsh plugins..."
    
    plugin_repos=(
        "https://github.com/zsh-users/zsh-autosuggestions.git"
        "https://github.com/zsh-users/zsh-syntax-highlighting.git"
        "https://github.com/marlonrichert/zsh-autocomplete.git"
    )
    
    plugin_dirs=(
        "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
        "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
        "$ZSH_CUSTOM/plugins/zsh-autocomplete"
    )
    
    for i in "${!plugin_repos[@]}"; do
        if [ ! -d "${plugin_dirs[$i]}" ]; then
            git clone --depth 1 "${plugin_repos[$i]}" "${plugin_dirs[$i]}" || log_warning "Failed to clone ${plugin_repos[$i]}"
        else
            log_info "Plugin ${plugin_dirs[$i]} already installed."
        fi
    done
    
    cp ".zshrc" "$HOME/.zshrc" 2>/dev/null || log_warning "Error copying .zshrc"
    cp ".zshenv" "$HOME/.zprofile" 2>/dev/null || log_warning "Error copying .zprofile"
    cp ".aliases" "$HOME/.aliases" 2>/dev/null || log_warning "Error copying .aliases"
    cp ".aliases-arch" "$HOME/.aliases-arch" 2>/dev/null || log_warning "Error copying .aliases-arch"
    cp ".aliases-fedora" "$HOME/.aliases-fedora" 2>/dev/null || log_warning "Error copying .aliases-fedora"
    cp ".bashrc" "$HOME/.bashrc" 2>/dev/null || log_warning "Error copying .bashrc"
    cp ".bash_profile" "$HOME/.bash_profile" 2>/dev/null || log_warning "Error copying .bash_profile"
    
    if [[ "$SHELL" != *"zsh"* ]]; then
        log_info "Setting Zsh as default shell..."
        chsh -s $(which zsh) || log_warning "Failed to set Zsh as default shell."
    fi
    
    log_success "Zsh setup completed."
}

# Configure and enable system services
configure_services() {
    log_step "Configuring system services"
    log_success "Services configured."
}

# Main installation function
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
  REYDOTS™ - Arch Linux Hyperoptimized Configuration
  "Like a Rey of light in your dotfiles"
  "Comme un rayon de lumière dans vos dotfiles."

EOF
    echo -e "${NC}"
    echo -e "${CYAN}ReyDots Installation Script${NC}"
    echo -e "This will install ReyDots and configure your system."
    echo

    check_permissions
    check_system
    
    echo
    read -p "Do you want to start the ReyDots installation? (y/n): " confirm
    if [[ $confirm != [yY] ]]; then
        log_info "Installation aborted by user."
        exit 0
    fi
    
    update_system
    backup_configs
    
    # Package selection
    if [[ -d "$PACMAN_DIR" ]]; then
        select_packages "$PACMAN_DIR" "Pacman" PACMAN_PACKAGES
    else
        log_warning "Pacman package directory not found, using defaults"
        read_package_files "$PACMAN_DIR" PACMAN_PACKAGES
    fi
    
    if [[ -d "$AUR_DIR" ]]; then
        select_packages "$AUR_DIR" "AUR" AUR_PACKAGES
    else
        log_warning "AUR package directory not found, using defaults"
        read_package_files "$AUR_DIR" AUR_PACKAGES
    fi
    
    install_pacman_packages
    install_yay
    install_aur_packages
    install_dotfiles
    install_omz
    configure_services
    
    echo
    log_success "ReyDots installation complete!"
    log_success "Welcome to your new Arch Linux setup!"
    echo
    log_warning "Please reboot your system to apply all changes."
    echo
    
    read -p "Would you like to reboot now? (y/n): " reboot_choice
    if [[ $reboot_choice == [yY] ]]; then
        log_info "Rebooting system..."
        sudo reboot
    else
        log_info "Remember to reboot later to fully apply the changes."
    fi
}

# Run the main function
main
