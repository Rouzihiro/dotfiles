#!/bin/bash

# Color definitions
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'


# ===============================================
# Configuration Variables - EDIT THESE IF NEEDED
# ===============================================
DOTFILES_SOURCE="$HOME/dotfiles/"  # Change this to your dotfiles location
# ===============================================


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

# Package lists for Fedora
DNF_PACKAGES=(
    # System and desktop environment
    "hyprland" "waybar" "hypridle" "hyprlock" 
    "power-profiles-daemon"  # Power management
    "rofi"  # App launcher
    "wayland-utils"  # Wayland utilities
	"btop"

    # Terminal and shell
    "zsh" "foot"  # Terminals
    "bat" "fzf"  # Shell enhancements
	"duf" "ncdu" "tree"
    "tmux"  # Terminal multiplexer
    "fastfetch"  # System info

    # Utilities
    "aria2" "grim" "slurp" "brightnessctl" 
    "mediainfo" "jq" "bc" "trash-cli" "unzip"
	"ntfs-3g" "highlight"
    "blueman"  # Bluetooth
    "curlftpfs"  # FTP mounting
    "vifm"  # File manager
    "thunar"  # GUI file manager
    "xdg-user-dirs"  # Default user directories
    "yad"  # GUI dialogs
    "rsync"  # File syncing
    "swappy"  # Screenshot editing

	# language
		"hunspell-de"
		"tesseract"
		"tesseract-data-eng"
		"tesseract-data-deu"

    # Multimedia
    "ffmpegthumbs" "ImageMagick" "imv" "vlc" "yt-dlp"
    "pamixer"  # Audio control

    # Development
	"lazygit" "git-delta"
    "jdk-openjdk" "nodejs" "npm"  # Programming
    "texmaker" # LaTeX

    # Graphics/GPU
    "mesa-utils" "vulkan-tools"

    # Fonts and themes
  	"otf-font-awesome" "ttf-droid" "ttf-fira-code" "ttf-fantasque-nerd"
	"ttf-jetbrains-mono" "ttf-jetbrains-mono-nerd"
  	"ttf-firacode-nerd" "ttf-hack-nerd" "ttf-cascadia-code-nerd"
  	"ttf-font-awesome" "ttf-dejavu" "noto-fonts"

    # Applications
    "zathura" "zathura-cb" "zathura-pdf-mupdf"  # Document viewers
    "neovim"  # Text editor
    "swww"  # Wallpaper utility
)

# List of archive files to extract after copying
THEME_ARCHIVES=(
#    "$HOME/.local/share/icons/BigSur.tar.xz"
)

# Check if script is run by root
check_permissions() {
    if [[ $EUID -eq 0 ]]; then
        log_error "Do not run this script with sudo. Run as a normal user."
        exit 1
    fi
}

# Check for Fedora-based distro
check_system() {
    if ! command -v dnf &> /dev/null; then
        log_error "This script is designed for Fedora-based distributions only."
        exit 1
    fi
    
    log_info "System check passed. Continuing installation..."
}

# Update system packages
update_system() {
    log_step "Updating system packages"
    sudo dnf upgrade --refresh -y || {
        log_warning "System update completed with some warnings. Continuing..."
    }
}

# Install packages from official repositories
install_dnf_packages() {
    log_step "Installing packages from official repositories"
    
    # Check for existing packages to avoid reinstalling
    local to_install=()
    for pkg in "${DNF_PACKAGES[@]}"; do
        if ! rpm -q "$pkg" &> /dev/null; then
        to_install+=("$pkg")
        fi
    done

    if [ ${#to_install[@]} -eq 0 ]; then
        log_info "All official packages are already installed."
    else
        log_info "Installing ${#to_install[@]} packages..."
        sudo dnf install -y --skip-unavailable"${to_install[@]}" || {
            log_error "Failed to install some packages. Please check the output above."
            read -p "Do you want to continue anyway? (y/n): " continue_choice
            [[ $continue_choice != [yY] ]] && exit 1
        }
    fi
}

# Install sources from COPR
install_sources() {
	sudo dnf copr enable atim/starship -y
	sudo dnf copr enable sneexy/zen-browser -y
	sudo dnf copr enable atim/lazygit -y
	sudo dnf copr enable che/nerd-fonts -y
        }

# Install Oh My Zsh and plugins
install_omz() {
    log_step "Setting up Zsh environment"
    
    # Check if zsh is installed
    if ! command -v zsh &> /dev/null; then
        log_error "Zsh is not installed. Please run the script again after fixing this issue."
        exit 1
    fi
    
    # Check if Oh My Zsh is already installed
    if [ -d "$HOME/.oh-my-zsh" ]; then
        log_info "Oh My Zsh is already installed."
    else
        log_info "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi
    
    # Set up plugins directory
    ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
    
    # Install plugins
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
    
    # Copy zsh configuration files
    cp ".zshrc" "$HOME/.zshrc" 2>/dev/null || log_warning "Error copying .zshrc"
    cp ".zshenv" "$HOME/.zprofile" 2>/dev/null || log_warning "Error copying .zprofile"
 		cp ".bashrc" "$HOME/.bashrc" 2>/dev/null || log_warning "Error copying .bashrc"
		cp ".bash_profile" "$HOME/.bash_profile" 2>/dev/null || log_warning "Error copying .bash_profile"
    
    # Set zsh as default shell
    if [[ "$SHELL" != *"zsh"* ]]; then
        log_info "Setting Zsh as default shell..."
        chsh -s $(which zsh) || log_warning "Failed to set Zsh as default shell. You can do this manually later."
    fi
    
    log_success "Zsh setup completed."
}

# Configure and enable system services
configure_services() {
    log_step "Configuring system services"
    
    # Enable user services
    log_info "Starting user services..."
    
    # Enable hypridle only if it exists
    if command -v hypridle &> /dev/null; then
        systemctl --user enable hypridle.service || log_warning "Failed to enable hypridle.service"
        systemctl --user start hypridle.service || log_warning "Failed to start hypridle.service"
    else
        log_warning "Hypridle not found. Skipping service setup."
    fi

    log_success "Services configured."
}

# Main installation function
main() {
    clear

    # Print ASCII art header
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

    # Check basic requirements
    check_permissions
    check_system
    
    # Confirm installation
    echo
    read -p "Do you want to start the ReyDots installation? (y/n): " confirm
    if [[ $confirm != [yY] ]]; then
        log_info "Installation aborted by user."
        exit 0
    fi
    
    # Run installation steps
    update_system
	install_sources 
    install_omz
    install_dnf_packages
    configure_services
    
    # Installation complete
    echo
    log_success "HyprDots installation complete!"
    log_success "Welcome to your new Hyprland desktop environment!"
    echo
    log_warning "Please reboot your system to apply all changes."
    echo
    
	    # Prompt for reboot
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
