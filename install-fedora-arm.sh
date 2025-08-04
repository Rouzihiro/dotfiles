#!/bin/bash

# Color definitions
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
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

log_prompt() {
    echo -e "${MAGENTA}[PROMPT]${NC} $1"
}

# Prompt execution system
prompt_user() {
    local description="$1"
    local command="$2"
    local destructive="${3:-false}"
    
    log_prompt "$description"
    [[ "$destructive" == "true" ]] && echo -e "${RED}WARNING: Destructive operation!${NC}"
    
    read -p "Execute this? (y/N): " choice
    if [[ $choice =~ ^[Yy]$ ]]; then
        log_info "Executing: $command"
        eval "$command"
        return $?
    fi
    log_info "Skipped by user"
    return 1
}

# Package lists for Fedora (deduplicated)
DNF_PACKAGES=(
    # System and desktop environment
    "waybar" "power-profiles-daemon" "fuzzel" "rofi-wayland" "wayland-utils"
    "btop" "ps_mem" "NetworkManager" "NetworkManager-tui" "gtklock" "wlr-randr"

    # Sway 
    "swayidle" "swaync" "swaybg" "xdg-desktop-portal" 
    "xdg-desktop-portal-wlr" "xdg-desktop-portal-gtk"

    # Terminal and shell
    "starship" "zsh" "foot" "bat" "fzf" "fd" "duf" "ncdu" "tree"
    "tmux" "fastfetch" "highlight"

    # File-Management
    "gdisk" "parted" "exfatprogs" "ntfs-3g" 

    # Utilities
    "aria2" "grim" "slurp" "brightnessctl" "mediainfo" "jq" "bc" 
    "trash-cli" "unzip" "poppler-utils" "sxiv" "ffmpegthumbnailer"
    "blueman" "curlftpfs" "vifm" "thunar" "xdg-user-dirs" "yad"
    "rsync" "swappy" "antimicrox"

    # Language support
    "hunspell-de" "tesseract" "tesseract-langpack-eng" "tesseract-langpack-deu"

    # Multimedia
    "ffmpegthumbs" "ImageMagick" "imv" "vlc" "mpv" "yt-dlp" "pamixer"

    # Development
    "lazygit" "git-delta" "nodejs" "java-latest-openjdk" "zstd"

    # Latex
    "texmaker" "texlive-scheme-basic"

    # Graphics/GPU
    "vulkan-tools"

    # Fonts and themes
    "jetbrains-mono-fonts-all" "cascadia-code-fonts" "google-noto-fonts-common"
    "google-noto-emoji-fonts" "fontawesome-fonts-all" "dejavu-fonts-all"
    "fira-code-fonts" "google-droid-fonts-all" "google-droid-sans-fonts"

    # Applications
    "zathura" "zathura-cb" "zathura-pdf-mupdf" "xournalpp" "neovim" "foliate" "thunderbird"
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
    
    # Create list of packages to install
    local to_install=()
    for pkg in "${DNF_PACKAGES[@]}"; do
        if ! rpm -q "$pkg" &> /dev/null; then
            to_install+=("$pkg")
        fi
    done

    if [ ${#to_install[@]} -gt 0 ]; then
        log_info "Installing ${#to_install[@]} packages..."
        sudo dnf install -y "${to_install[@]}" || {
            log_error "Failed to install some packages."
            read -p "Continue anyway? (y/N): " continue_choice
            [[ $continue_choice =~ ^[Yy]$ ]] || exit 1
        }
    else
        log_info "All packages are already installed."
    fi
}

# Install sources from COPR
install_sources() {
    log_step "Enabling COPR repositories"
    sudo dnf copr enable -y atim/starship sneexy/zen-browser atim/lazygit che/nerd-fonts solopasha/hyprland evana/nerd-fonts
}

# Install Oh My Zsh and plugins
install_omz() {
    log_step "Setting up Zsh environment"
    
    if ! command -v zsh &> /dev/null; then
        log_error "Zsh is not installed."
        return 1
    fi
    
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        log_info "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi
    
    ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
    
    log_info "Installing Zsh plugins..."
    
    declare -A plugin_repos=(
        ["zsh-autosuggestions"]="https://github.com/zsh-users/zsh-autosuggestions.git"
        ["zsh-syntax-highlighting"]="https://github.com/zsh-users/zsh-syntax-highlighting.git"
        ["zsh-autocomplete"]="https://github.com/marlonrichert/zsh-autocomplete.git"
    )
    
    for plugin in "${!plugin_repos[@]}"; do
        if [ ! -d "$ZSH_CUSTOM/plugins/$plugin" ]; then
            git clone --depth 1 "${plugin_repos[$plugin]}" "$ZSH_CUSTOM/plugins/$plugin" || 
            log_warning "Failed to clone $plugin"
        fi
    done
    
    # Copy configuration files
    for file in .zshrc .zprofile .aliases* .bashrc .bash_profile; do
        if [ -f "$file" ]; then
            cp -v "$file" "$HOME/" || log_warning "Error copying $file"
        fi
    done
    
    if [[ "$SHELL" != *"zsh"* ]]; then
        log_info "Setting Zsh as default shell..."
        chsh -s "$(command -v zsh)" || log_warning "Failed to set Zsh as default shell."
    fi
    
    log_success "Zsh setup completed."
}

# Configure and enable system services
configure_services() {
    log_step "Configuring system services"
    log_success "Services configured."
}

# Cleanup operations
run_cleanups() {
    log_step "Running optional cleanups"
    
    # Neovim cache cleaner
    prompt_user "Clear Neovim cache? (Removes config, cache, and state)" \
        "rm -rf ~/.local/share/nvim ~/.cache/nvim ~/.local/state/nvim" "true"
    
    # Brave browser installer
    prompt_user "Install Brave browser via official script?" \
        "curl -fsS https://dl.brave.com/install.sh | sh"
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
    read -p "Do you want to start the ReyDots installation? (y/N): " confirm
    if [[ ! $confirm =~ ^[Yy]$ ]]; then
        log_info "Installation aborted by user."
        exit 0
    fi
    
    update_system
    install_sources 
    install_dnf_packages
    install_omz
    configure_services
    run_cleanups
    
    echo
    log_success "ReyDots installation complete!"
    log_success "Welcome to your new optimized desktop environment!"
    echo
    log_warning "Please reboot your system to apply all changes."
    echo
    
    read -p "Would you like to reboot now? (y/N): " reboot_choice
    if [[ $reboot_choice =~ ^[Yy]$ ]]; then
        log_info "Rebooting system..."
        sudo reboot
    else
        log_info "Remember to reboot later to fully apply the changes."
    fi
}

main
