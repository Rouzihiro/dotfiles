# Prompt to install yay
prompt_install_yay() {
    if ! command -v yay &>/dev/null; then
        log_prompt "Would you like to install yay (AUR helper)? (y/N): "
        read -r yay_confirm
        if [[ "$yay_confirm" =~ ^[Yy]$ ]]; then
            log_step "Installing yay..."
            sudo pacman -S --noconfirm git base-devel || {
                log_error "Failed to install base-devel and git"
                return
            }
            tmp_dir=$(mktemp -d)
            git clone https://aur.archlinux.org/yay.git "$tmp_dir/yay" &&
            cd "$tmp_dir/yay" &&
            makepkg -si --noconfirm &&
            cd - && rm -rf "$tmp_dir"
            log_success "yay installed successfully!"
        else
            log_info "Skipping yay installation."
        fi
    else
        log_info "yay already installed."
    fi
}

# Install for Arch
install_arch() {
    prompt_install_yay
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