#!/usr/bin/env bash
set -euo pipefail

PALETTE="$HOME/Downloads/palette.toml"

FIELDS=(
bg
bg_subtle
bg_muted
fg
fg_dim
accent
fg_on_accent
success
warning
error
cursor
sel_bg
sel_fg
color0
color1
color2
color3
color4
color5
color6
color7
color8
color9
color10
color11
color12
color13
color14
color15
)

# Create palette file
if [[ ! -f "$PALETTE" ]]; then
    mkdir -p "$(dirname "$PALETTE")"
    printf "[palette]\n" > "$PALETTE"
fi


# Build fzf menu with current values
menu=""

for key in "${FIELDS[@]}"; do
    value=$(grep -E "^$key[[:space:]]*=" "$PALETTE" \
        | sed -E 's/.*"(#[A-Fa-f0-9]+)".*/\1/' \
        | head -n1)

    if [[ -n "$value" ]]; then
        menu+=$(printf "%-15s %s\n" "$key" "$value")
    else
        menu+=$(printf "%-15s %s\n" "$key" "")
    fi
done


selection=$(printf "%s" "$menu" | fzf \
    --prompt="Palette color > " \
    --height=20 \
    --layout=reverse \
    --border)

[[ -z "$selection" ]] && exit 0

key=$(awk '{print $1}' <<< "$selection")


# Pick color
if command -v hyprpicker >/dev/null 2>&1; then

    color=$(
        hyprpicker -a 2>&1 |
        grep -m1 -oE '#[[:xdigit:]]{6}'
    )

elif command -v wl-color-picker >/dev/null 2>&1; then

    color=$(
        wl-color-picker |
        grep -m1 -oE '#[[:xdigit:]]{6}'
    )

else
    echo "No Wayland color picker found."
    echo "Install hyprpicker."
    exit 1
fi


if [[ -z "$color" ]]; then
    echo "No color selected."
    exit 1
fi


# Update or append key
tmp=$(mktemp)

awk \
-v key="$key" \
-v color="$color" '

BEGIN {
    updated=0
}

/^\[palette\]/ {
    print
    next
}

$1 == key {
    print key " = \"" color "\""
    updated=1
    next
}

{
    print
}

END {
    if (!updated)
        print key " = \"" color "\""
}

' "$PALETTE" > "$tmp"


mv "$tmp" "$PALETTE"


echo "✔ $key → $color"
