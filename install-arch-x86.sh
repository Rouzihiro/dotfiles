l!/bin/bash

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

# Package lists
PACMAN_PACKAGES=(
    # System and desktop environment
    "waybar" 
    "power-profiles-daemon"  # Power management - error on surface
    "swaync"  # Notifications
	"swaybg"
    "rofi" "fuzzel" # App launcher
    "wayland-utils"  # Wayland utilities
	"btop"
	
	#Hyprland
	#"hyprland" "xdg-desktop-portal-hyprland"
	#"hyprpaper" 
	"hyprlock" 
	#"hypridle" 
	#"polkit-gnome"

	# Sway
	#"i3blocks" "autotiling-rs" "swaylock" 
	"swayidle"
	#"xdg-desktop-portal" "xdg-desktop-portal-wlr" "xdg-desktop-portal-gtk"

    # Terminal and shell
    "zsh" "foot"  # Terminals
    "starship" "eza" "bat" "fzf"  # Shell enhancements
    "tmux"  # Terminal multiplexer
    "fastfetch"  # System info
	"duf" "ncdu" "highlight"

    # Utilities
    "aria2" "grim" "slurp" "brightnessctl" 
    "mediainfo" "jq" "bc" "trash-cli" "unzip"
	"ntfs-3g"
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
		"tesseract-data-eng"
		"tesseract-data-deu"

    # Multimedia
    "ffmpegthumbs" "imagemagick" "imv" "mpv" "yt-dlp"
    "pamixer"  # Audio control

    # Development
    "jdk-openjdk" "nodejs" "npm"  # Programming
    "texlive-latexextra" "texmaker" # LaTeX

    # Graphics/GPU
    "mesa-utils" "vulkan-tools"
	"xf86-video-intel" "vulkan-intel" "mesa" "libglvnd"

    # Fonts and themes
  	"otf-font-awesome" "ttf-droid" "ttf-fira-code" "ttf-fantasque-nerd"
	"ttf-jetbrains-mono" "ttf-jetbrains-mono-nerd"
  	"ttf-firacode-nerd" "ttf-hack-nerd" "ttf-cascadia-code-nerd"
  	"ttf-font-awesome" "ttf-dejavu" "noto-fonts"

    # Applications
    "zathura" "zathura-cb" "zathura-pdf-mupdf"  # Document viewers
	"xournalpp" # PDF editor
    "neovim"  # Text editor
    "swww"  # Wallpaper utility

	# Browsers
	
	# Games
	#"lutris"

	#email-TUI
	"thunderbird" "ca-certificates"
)

AUR_PACKAGES=(
    # Browsers
	"librewolf-bin"
	"zen-browser-bin"  # Lightweight browser
	
	# Games
	#"heroic-games-launcher-bin"
	#"protonup-qt"

    # Fonts
    "adobe-source-code-pro-fonts"  # Monospace font
    "ttf-victor-mono"              # Programming font with ligatures

    # System Utilities
    # "uwsm"
    "wl-clipboard"      # Wayland clipboard tool
    "bibata-cursor-theme"  # Modern cursor theme

	# Development
	"lazygit" "git-delta" "openssh"
    "jdk-openjdk" "nodejs" "npm"  # Programming
    "texlive-latexextra" "texmaker" # LaTeX

    # Apps/Tools
	"ps_mem"
    "jdownloader2"      # Download manager
    "sdl2_sound"        # Audio library (for games/apps)
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
					"/bin/"
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
    
    # Check for existing packages to avoid reinstalling
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
    
    # Dependencies for yay
    sudo pacman -S --needed --noconfirm git base-devel
    
    # Create temp directory and clone yay
    local temp_dir=$(mktemp -d)
    git clone https://aur.archlinux.org/yay.git "$temp_dir"
    cd "$temp_dir" || {
        log_error "Failed to navigate to temporary directory for yay installation."
        exit 1
    }
    
    # Build and install yay
    makepkg -si --noconfirm || {
        log_error "Failed to install yay. Please install it manually."
        exit 1
    }
    
    # Clean up
    cd - > /dev/null
    rm -rf "$temp_dir"
    
    log_success "Yay installed successfully."
}

# Install packages from AUR
install_aur_packages() {
    log_step "Installing packages from AUR"
    
    # Check for existing packages to avoid reinstalling
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

    # Verify dotfiles source exists
    if [ ! -d "$DOTFILES_SOURCE" ]; then
        log_error "Dotfiles source directory not found at: $DOTFILES_SOURCE"
        log_error "Please clone the dotfiles repository or update DOTFILES_SOURCE in this script."
        exit 1
    fi

    # Create necessary directories
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
    
      # Copy configuration files
    if [ -d "$DOTFILES_SOURCE/.config" ]; then
        cp -r "$DOTFILES_SOURCE/.config/"* "$HOME/.config/" || log_warning "Error copying .config files"
        log_info "Copied configuration files to ~/.config/"
    else
        log_error "Config directory not found in $DOTFILES_SOURCE!"
        exit 1
    fi
    
    # Copy local files
    if [ -d "$DOTFILES_SOURCE/.local" ]; then
        cp -r "$DOTFILES_SOURCE/.local/"* "$HOME/.local/" || log_warning "Error copying .local files"
        log_info "Copied local files to ~/.local/"
    fi

		    # Copy local files
    if [ -d "$DOTFILES_SOURCE/bin" ]; then
        cp -r "$DOTFILES_SOURCE/bin/"* "$HOME/bin/" || log_warning "Error copying bin files"
        log_info "Copied local files to ~/bin/"
    fi
    
    # Copy theme files
    if [ -d "$DOTFILES_SOURCE/.themes" ]; then
        cp -r "$DOTFILES_SOURCE/.themes/"* "$HOME/.themes/" || log_warning "Error copying theme files"
        log_info "Copied theme files to ~/.themes/"
    fi
    
    # Copy icon files
    if [ -d "$DOTFILES_SOURCE/.icons" ]; then
        cp -r "$DOTFILES_SOURCE/.icons/"* "$HOME/.icons/" || log_warning "Error copying icon files"
        log_info "Copied icon files to ~/.icons/"
    fi
    
    # Copy wallpapers if they exist
    if [ -d "$DOTFILES_SOURCE/.walls" ]; then
        cp -r "$DOTFILES_SOURCE/.walls/"* "$HOME/Pictures/wallpapers/" 2>/dev/null || log_warning "Error copying wallpapers"
        log_info "Copied wallpapers to ~/Pictures/wallpapers/"
    fi
    
    log_success "ReyDots files installed successfully from $DOTFILES_SOURCE"
}

# Extract compressed theme/icon archives
extract_theme_archives() {
    log_step "Extracting theme and icon archives"
    
    local extracted_count=0
    
    for archive in "${THEME_ARCHIVES[@]}"; do
        if [ -f "$archive" ]; then
            log_info "Extracting $(basename "$archive")"
            
            # Get the directory where the archive is located
            local extract_dir=$(dirname "$archive")
            
            # Extract the archive
            tar -xf "$archive" -C "$extract_dir" && {
                # Remove the archive after successful extraction
                rm "$archive" && log_info "Removed archive after extraction"
                ((extracted_count++))
            } || {
                log_warning "Failed to extract: $archive"
            }
        else
            log_warning "Archive not found: $archive"
        fi
    done
    
    if [ $extracted_count -eq ${#THEME_ARCHIVES[@]} ]; then
        log_success "All theme and icon archives extracted successfully"
    else
        log_warning "Extracted $extracted_count out of ${#THEME_ARCHIVES[@]} archives"
    fi
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
	cp ".aliases" "$HOME/.aliases" 2>/dev/null || log_warning "Error copying .aliases"
	cp ".aliases-arch" "$HOME/.aliases-arch" 2>/dev/null || log_warning "Error copying .aliases-arch"
	cp ".aliases-fedora" "$HOME/.aliases-fedora" 2>/dev/null || log_warning "Error copying .aliases-fedora"
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
    #log_info "Enabling user services..."
    #systemctl --user enable pipewire.service || log_warning "Failed to enable pipewire.service"
    #systemctl --user enable pipewire-pulse.service || log_warning "Failed to enable pipewire-pulse.service"
    #systemctl --user enable wireplumber.service || log_warning "Failed to enable wireplumber.service"
    
    # Try to start user services
    log_info "Starting user services..."
    #systemctl --user start pipewire.service || log_warning "Failed to start pipewire.service"
    #systemctl --user start pipewire-pulse.service || log_warning "Failed to start pipewire-pulse.service"
    #systemctl --user start wireplumber.service || log_warning "Failed to start wireplumber.service"

    # Enable system services
    #log_info "Enabling system services..."
    # sudo systemctl enable sddm.service || log_warning "Failed to enable sddm.service"
    
    # Enable Bluetooth if available
    # if pacman -Q bluez bluez-utils &> /dev/null; then
    #    log_info "Enabling Bluetooth service..."
    #    sudo systemctl enable bluetooth.service || log_warning "Failed to enable bluetooth.service"
    # fi
    
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
    backup_configs
    install_pacman_packages
    install_yay
    install_aur_packages
    install_dotfiles
    extract_theme_archives
    install_omz
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
