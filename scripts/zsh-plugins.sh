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

    # Install Oh My Zsh if missing
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        log_info "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    else
        log_info "Oh My Zsh already installed."
    fi

    # Plugin directory
    ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

    # Plugins
    log_info "Installing Zsh plugins..."
    declare -A plugin_repos=(
        ["zsh-autosuggestions"]="https://github.com/zsh-users/zsh-autosuggestions.git"
        ["zsh-syntax-highlighting"]="https://github.com/zsh-users/zsh-syntax-highlighting.git"
        ["zsh-autocomplete"]="https://github.com/marlonrichert/zsh-autocomplete.git"
    )

    for plugin in "${!plugin_repos[@]}"; do
        plugin_dir="$ZSH_CUSTOM/plugins/$plugin"
        if [ ! -d "$plugin_dir" ]; then
            git clone --depth 1 "${plugin_repos[$plugin]}" "$plugin_dir" || 
                log_warning "Failed to clone $plugin"
        else
            log_info "$plugin already exists."
        fi
    done

    # Optional: copy dotfiles if they exist
    log_info "Copying local dotfiles if present..."
    for file in .zshrc .zprofile .aliases .bashrc .bash_profile; do
        [[ -f "$file" ]] && cp -v "$file" "$HOME/" || true
    done

    # Set default shell to zsh
    if [[ "$SHELL" != *zsh ]]; then
        log_info "Changing default shell to Zsh..."
        chsh -s "$(command -v zsh)" || log_warning "Failed to set Zsh as default shell."
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

