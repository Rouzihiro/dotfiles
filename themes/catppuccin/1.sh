#!/bin/bash

extract_colors() {
    local tmux_colors="$HOME/dotfiles/themes/catppuccin/tmux-colors.conf"
    local starship_config="$HOME/.config/starship.toml"
    
    # Check if files exist
    if [[ ! -f "$tmux_colors" ]]; then
        tmux_colors="$HOME/dotfiles/themes/catppuccin/tmux-colors.conf"
        if [[ ! -f "$tmux_colors" ]]; then
            echo "Error: tmux-colors.conf not found"
            return 1
        fi
    fi
    
    if [[ ! -f "$starship_config" ]]; then
        echo "Error: starship.toml not found at $starship_config"
        return 1
    fi
    
    # Check if palette already exists
    if grep -q "\[palettes.Catppuccin\]" "$starship_config"; then
        echo "Everforest palette already exists in starship.toml"
        return 0
    fi
    
    # Extract colors and append to starship config
    {
        echo ""
        echo "[palettes.Catppuccin]"
        grep -E '(base|text|crust|sig1|sig2|on_sig1|on_sig2|on_sigbg|sig_bg|sig_surface_high|red)="?#[0-9a-fA-F]{6}"?' "$tmux_colors" | \
        sed 's/="/ = "/g' | \
        sed 's/"$/"/'
    } >> "$starship_config"
    
    echo "Successfully added Catppuccin palette to starship.toml"
}

extract_colors
