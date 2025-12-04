#!/bin/bash

# -------------------- Colors and Logging --------------------
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

log_info()     { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warning()  { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error()    { echo -e "${RED}[ERROR]${NC} $1"; }
log_step()     { echo -e "${BLUE}[STEP]${NC} $1"; }
log_success()  { echo -e "${CYAN}[SUCCESS]${NC} $1"; }

# -------------------- Install Oh My Zsh --------------------
install_omz() {
    log_step "Setting up Zsh environment"

    # Check zsh availability
    if ! command -v zsh &>/dev/null; then
        log_error "Zsh is not installed. Install it first."
        return 1
    fi

    # Install or update Oh My Zsh
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        log_info "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    else
        log_info "Updating Oh My Zsh..."
        cd "$HOME/.oh-my-zsh" && git pull
    fi

    # Plugin directory
    ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

    # Function to install or update a plugin
    setup_plugin() {
        local plugin_name="$1"
        local repo_url="$2"
        local plugin_dir="$ZSH_CUSTOM/plugins/$plugin_name"
        
        mkdir -p "$(dirname "$plugin_dir")"
        
        if [ ! -d "$plugin_dir" ]; then
            log_info "Installing $plugin_name..."
            git clone --depth 1 "$repo_url" "$plugin_dir" 2>/dev/null || 
                log_warning "Failed to clone $plugin_name"
        else
            log_info "Updating $plugin_name..."
            cd "$plugin_dir" && git pull 2>/dev/null ||
                log_warning "Failed to update $plugin_name"
        fi
    }

    # Install/update plugins
    log_info "Setting up Zsh plugins..."
    setup_plugin "zsh-autosuggestions" "https://github.com/zsh-users/zsh-autosuggestions.git"
    setup_plugin "zsh-syntax-highlighting" "https://github.com/zsh-users/zsh-syntax-highlighting.git"
    setup_plugin "zsh-autocomplete" "https://github.com/marlonrichert/zsh-autocomplete.git"

    # Optional: copy dotfiles if they exist
    log_info "Copying local dotfiles if present..."
    for file in .zshrc .zprofile .aliases .bashrc .bash_profile; do
        if [[ -f "$file" ]]; then
            cp -v "$file" "$HOME/"
        fi
    done

    # Set default shell to zsh
    current_shell="$(basename "$SHELL")"
    if [[ "$current_shell" != "zsh" ]]; then
        log_info "Changing default shell to Zsh..."
        zsh_path="$(command -v zsh)"
        if [ -n "$zsh_path" ]; then
            chsh -s "$zsh_path" || log_warning "Failed to set Zsh as default shell."
        else
            log_warning "Could not find zsh binary path."
        fi
    else
        log_info "Zsh is already the default shell."
    fi

    log_success "Zsh setup completed."
}

# -------------------- (Optional) Systemd Service Config --------------------
configure_services() {
    log_step "Configuring system services (placeholder)"
    # Example: sudo systemctl enable --now some-service
    log_success "Services configured."
}

# -------------------- Entry --------------------
main() {
    install_omz
    # configure_services # Uncomment if needed
}

main "$@"
