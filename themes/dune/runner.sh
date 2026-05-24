#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Parse theme.conf using awk
parse_theme() {
    awk -F'=' '/^[a-z_]+/ {
        gsub(/[[:space:]]*/, "", $1);
        gsub(/[[:space:]]*/, "", $2);
        print $1 "=" $2
    }' "$1"
}

# Source the parsed output (now in valid shell format)
eval "$(parse_theme "$SCRIPT_DIR/theme.conf")"

# Verify colors
if [[ -z "$bg" || -z "$fg" ]]; then
    echo "Error: Could not parse color values from theme.conf"
    exit 1
fi

echo "✓ Using colors from theme.conf"
echo "  bg: $bg, fg: $fg, primary: $primary"

# Generate yazi.toml from template
sed -e "s/{{bg}}/$bg/g" \
    -e "s/{{bg_alt}}/$bg_alt/g" \
    -e "s/{{fg}}/$fg/g" \
    -e "s/{{primary}}/$primary/g" \
    -e "s/{{secondary}}/$secondary/g" \
    -e "s/{{disabled}}/$disabled/g" \
    -e "s/{{alert}}/$alert/g" \
    "$SCRIPT_DIR/yazi.template" > "$SCRIPT_DIR/yazi.toml"

echo "✓ Generated yazi.toml"
