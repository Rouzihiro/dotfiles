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
	"waybar"
    "power-profiles-daemon"  # Power management
    "fuzzel" "rofi-wayland"  # App launcher
    "wayland-utils"  # Wayland utilities
    "btop" "ps_mem" "NetworkManager" "NetworkManager-tui"

	# Hyprland
	# "hyprland" "hyprlock" "hypridle"
	# "hyprsysteminfo"

	# Sway 
	#"swayidle" "swaylock" 

    # Terminal and shell
    "zsh" "foot"  # Terminals
    "bat" "fzf" "fd" # Shell enhancements
    "duf" "ncdu" "tree"
    "tmux"  # Terminal multiplexer
    "fastfetch"  # System info

	# File-Management
	"gdisk" "parted" "exfat-utils" "ntfs-3g" 

    # Utilities
    "aria2" "grim" "slurp" "brightnessctl" 
    "mediainfo" "jq" "bc" "trash-cli" "unzip"
    "highlight"
	"poppler-utils" "sxiv" "ffmpegthumbnailer"
    "blueman"  # Bluetooth
    "curlftpfs"  # FTP mounting
    "vifm"  # File manager
    "thunar"  # GUI file manager
    "xdg-user-dirs"  # Default user directories
    "yad"  # GUI dialogs
    "rsync"  # File syncing
    "swappy"  # Screenshot editing
	"antimicrox"

    # language
    "hunspell-de"
    "tesseract"
    "tesseract-langpack-eng"
    "tesseract-langpack-deu"

    # Multimedia
    "ffmpegthumbs" "ImageMagick" "imv" "vlc" "mpv" "yt-dlp"
    "pamixer"  # Audio control

    # Development
    "lazygit" "git-delta"
    "nodejs"  # Programming
    "java-latest-openjdk"
	"zstd"

	# Latex
    "texmaker"
	"texlive-scheme-basic" #"texlive-scheme-full"

    # Graphics/GPU
    "vulkan-tools"

    # Fonts and themes
    "jetbrains-mono-fonts-all"
    "cascadia-code-fonts"
    "google-noto-fonts-common"
    "google-noto-emoji-fonts"
    "fontawesome-fonts-all"
    "dejavu-fonts-all"
    "fira-code-fonts" 
    "google-droid-fonts-all"

    # Applications
    "zathura" "zathura-cb" "zathura-pdf-mupdf"  # Document viewers
	"xournalpp" # PDF editor
    "neovim"  # Text editor
	"foliate" # Book reading

	# email
	"thunderbird"

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
    
    local to_install=()
    local missing_packages=()
    
    for pkg in "${DNF_PACKAGES[@]}"; do
        if ! rpm -q "$pkg" &> /dev/null; then
            if dnf list available "$pkg" &> /dev/null; then
                to_install+=("$pkg")
            else
                missing_packages+=("$pkg")
            fi
        fi
    done

    if [ ${#missing_packages[@]} -gt 0 ]; then
        log_warning "These packages aren't available: ${missing_packages[*]}"
    fi

    if [ ${#to_install[@]} -gt 0 ]; then
        log_info "Installing ${#to_install[@]} packages..."
        sudo dnf install -y "${to_install[@]}" || {
            log_error "Failed to install some packages."
            read -p "Continue anyway? (y/n): " continue_choice
            [[ $continue_choice != [yY] ]] && exit 1
        }
    else
        log_info "All available packages are already installed."
    fi
}

# Install sources from COPR
install_sources() {
    sudo dnf copr enable atim/starship -y
    sudo dnf copr enable sneexy/zen-browser -y
    sudo dnf copr enable atim/lazygit -y
    sudo dnf copr enable che/nerd-fonts -y
	sudo dnf copr enable wef/wlogout -y
	sudo dnf copr enable solopasha/hyprland -y 
}

# Install Oh My Zsh and plugins
install_omz() {
    log_step "Setting up Zsh environment"
    
    if ! command -v zsh &> /dev/null; then
        log_error "Zsh is not installed."
        exit 1
    fi
    
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
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
        fi
    done
    
    cp ".zshrc" "$HOME/.zshrc" 2>/dev/null || log_warning "Error copying .zshrc"
	cp ".zprofile" "$HOME/.zprofile" 2>/dev/null || log_warning "Error copying .zprofile"
	cp .aliases* "$HOME/" 2>/dev/null || log_warning "Error copying alias files"
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

	   # Enable hypridle only if it exists
    if command -v hypridle &> /dev/null; then
        systemctl --user enable hypridle.service || log_warning "Failed to enable hypridle.service"
        systemctl --user start hypridle.service || log_warning "Failed to start hypridle.service"
    else
        log_warning "Hypridle not found. Skipping service setup."
    fi
    
    # Configure swayidle (replacement for hypridle)
#     if command -v swayidle &> /dev/null; then
#         log_info "Configuring swayidle (hypridle alternative)"
#
#         SWAYIDLE_CONFIG="$HOME/.config/swayidle/config"
#         mkdir -p "$(dirname "$SWAYIDLE_CONFIG")"
#
#         cat > "$SWAYIDLE_CONFIG" << EOF
# timeout 300 'swaylock -f'
# timeout 600 'hyprctl dispatch dpms off'
# resume 'hyprctl dispatch dpms on'
# EOF
#
#         log_info "Created swayidle configuration"
#     else
#         log_warning "swayidle not found"
#     fi
#
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
    install_sources 
    install_omz
    install_dnf_packages
    configure_services
    
    echo
    log_success "ReyDots installation complete!"
    log_success "Welcome to your new Hyprland desktop environment!"
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

main
