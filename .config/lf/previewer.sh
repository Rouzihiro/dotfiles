#!/usr/bin/env bash
file="$1"
width="$2"
height="$3"
x="$4"
y="$5"

# Set terminal type for kitty protocol
export TERM=xterm-kitty

# Function to clear all Kitty images
clear_kitty_images() {
    printf "\e_Ga=d,d=A;\e\\" > /dev/tty
}

# Function to preview images
preview_image() {
    # Check if chafa is available
    if ! command -v chafa &> /dev/null; then
        echo "chafa not installed"
        return 1
    fi
    
    # Clear previous images first
    clear_kitty_images
    
    # Buffer the output of chafa
    output=$(chafa -f kitty --animate off -s "${width}x${height}" "$file" 2>/dev/null)
    
    if [ -n "$output" ]; then
        # Set cursor to correct position
        printf "\e[${y};${x}H" > /dev/tty
        # Print the chafa output
        printf "%s" "$output" > /dev/tty
        exit 1  # Exit with non-zero to force redraw on every preview
    fi
}

# Function to preview text files
preview_text() {
    # Clear images when showing text
    clear_kitty_images
    
    # Use bat if available for syntax highlighting
    if command -v bat &> /dev/null; then
        bat --style=numbers --color=always --paging=never "$file" 2>/dev/null
    else
        head -n "$height" "$file" 2>/dev/null
    fi
}

# Main logic
case "$file" in
    *.jpg|*.jpeg|*.png|*.gif|*.bmp|*.tiff|*.webp|*.ico)
        preview_image
        ;;
    *.pdf)
        # Clear images for PDF preview
        clear_kitty_images
        
        # Optional: preview PDFs with pdftoppm
        if command -v pdftoppm &> /dev/null; then
            temp_dir=$(mktemp -d)
            pdftoppm -jpeg -f 1 -singlefile "$file" "$temp_dir/preview" 2>/dev/null
            if [ -f "${temp_dir}/preview.jpg" ]; then
                preview_image "${temp_dir}/preview.jpg"
            fi
            rm -rf "$temp_dir"
        fi
        ;;
    *)
        preview_text
        ;;
esac

exit 0
