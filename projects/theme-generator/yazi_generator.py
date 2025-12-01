#!/bin/bash
# generate-all-yazi-themes.sh

HOME_DIR="$HOME"
TEMPLATES_DIR="$HOME_DIR/dotfiles/projects/templates"
THEMES_DIR="$HOME_DIR/dotfiles/themes"

# Find the template file
TEMPLATE_FILE=$(find "$TEMPLATES_DIR" -type f \( -name "*yazi*template*" -o -name "*yazi*.toml" \) | head -n1)

if [ -z "$TEMPLATE_FILE" ]; then
    echo "Error: No Yazi template found in $TEMPLATES_DIR"
    exit 1
fi

echo "Using template: $(basename "$TEMPLATE_FILE")"
echo ""

# Read template content
TEMPLATE_CONTENT=$(cat "$TEMPLATE_FILE")

# Find all theme folders with tmux-colors.conf
echo "Finding theme folders..."
THEME_FOLDERS=()
while IFS= read -r folder; do
    if [ -f "$folder/tmux-colors.conf" ]; then
        THEME_FOLDERS+=("$folder")
        echo "  - $(basename "$folder")"
    fi
done < <(find "$THEMES_DIR" -type d -mindepth 1 -maxdepth 1)

if [ ${#THEME_FOLDERS[@]} -eq 0 ]; then
    echo "No theme folders with tmux-colors.conf found!"
    exit 1
fi

echo ""
echo "Generating yazi.toml files..."
echo "(Existing yazi.toml files will be backed up as yazi.toml.backup)"
echo ""

# List of colors to extract
COLOR_NAMES=("base" "text" "crust" "sig1" "sig2" "on_sig1" "on_sig2" "on_sigbg" "sig_bg" "sig_surface_high" "red")

SUCCESSFUL=0
for theme_folder in "${THEME_FOLDERS[@]}"; do
    theme_name=$(basename "$theme_folder")
    echo "Processing $theme_name..."
    
    # Backup existing yazi.toml
    if [ -f "$theme_folder/yazi.toml" ]; then
        cp "$theme_folder/yazi.toml" "$theme_folder/yazi.toml.backup"
        echo "  ✓ Backed up existing yazi.toml"
    fi
    
    # Parse colors from tmux-colors.conf using multiple patterns
    declare -A COLORS
    
    for color_name in "${COLOR_NAMES[@]}"; do
        # Try different patterns to find the color
        color_value=$(
            # Pattern 1: name="#RRGGBB"
            grep -E "^[[:space:]]*${color_name}[[:space:]]*=[[:space:]]*\"#[0-9a-fA-F]{6}\"" "$theme_folder/tmux-colors.conf" |
            sed -E 's/^[[:space:]]*'"${color_name}"'[[:space:]]*=[[:space:]]*"([^"]+)".*$/\1/' |
            head -n1
        )
        
        # Pattern 2: set @name "#RRGGBB" (tmux format)
        if [ -z "$color_value" ]; then
            color_value=$(
                grep -E "set.*@?${color_name}[[:space:]]+\"#[0-9a-fA-F]{6}\"" "$theme_folder/tmux-colors.conf" |
                sed -E 's/.*set.*@?'"${color_name}"'[[:space:]]+\"([^"]+)\".*/\1/' |
                head -n1
            )
        fi
        
        # Pattern 3: $name="#RRGGBB"
        if [ -z "$color_value" ]; then
            color_value=$(
                grep -E "\\\$${color_name}[[:space:]]*=[[:space:]]*\"#[0-9a-fA-F]{6}\"" "$theme_folder/tmux-colors.conf" |
                sed -E 's/.*\$'"${color_name}"'[[:space:]]*=[[:space:]]*"([^"]+)".*/\1/' |
                head -n1
            )
        fi
        
        # Pattern 4: name: "#RRGGBB"
        if [ -z "$color_value" ]; then
            color_value=$(
                grep -E "^[[:space:]]*${color_name}[[:space:]]*:[[:space:]]*\"#[0-9a-fA-F]{6}\"" "$theme_folder/tmux-colors.conf" |
                sed -E 's/^[[:space:]]*'"${color_name}"'[[:space:]]*:[[:space:]]*"([^"]+)".*$/\1/' |
                head -n1
            )
        fi
        
        if [ -n "$color_value" ]; then
            COLORS["$color_name"]="$color_value"
        else
            echo "  Warning: Could not find color definition for '$color_name'"
            COLORS["$color_name"]="#000000"  # Default black
        fi
    done
    
    echo "  Extracted colors: ${!COLORS[*]}"
    
    # Merge template
    merged_content="$TEMPLATE_CONTENT"
    
    # Replace all color placeholders
    for color_name in "${!COLORS[@]}"; do
        placeholder="{{$color_name}}"
        color_value="${COLORS[$color_name]}"
        merged_content="${merged_content//$placeholder/$color_value}"
    done
    
    # Write yazi.toml
    echo "$merged_content" > "$theme_folder/yazi.toml"
    echo "  ✓ Generated yazi.toml"
    
    SUCCESSFUL=$((SUCCESSFUL + 1))
    
    # Clean up for next iteration
    unset COLORS
    declare -A COLORS
    
    echo ""
done

echo "=================================================="
echo "Successfully generated yazi.toml for $SUCCESSFUL/${#THEME_FOLDERS[@]} theme folders!"
