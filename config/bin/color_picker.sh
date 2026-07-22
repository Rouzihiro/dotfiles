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

# Create file if missing
if [[ ! -f "$PALETTE" ]]; then
    printf "[palette]\n" > "$PALETTE"
fi

field=$(printf "%s\n" "${FIELDS[@]}" | fzf --prompt="Palette key > ")
[[ -z "$field" ]] && exit 0

if command -v hyprpicker >/dev/null; then
    color=$(hyprpicker -a 2>/dev/null | tail -n1)

elif command -v wl-color-picker >/dev/null; then
    color=$(wl-color-picker | tail -n1)

else
    echo "Install hyprpicker or wl-color-picker."
    exit 1
fi

[[ -z "$color" ]] && exit 0

tmp=$(mktemp)

awk -v key="$field" -v val="$color" '
BEGIN{
    found=0
}

/^\[palette\]/{
    print
    next
}

$1==key{
    print key " = \"" val "\""
    found=1
    next
}

{
    print
}

END{
    if(!found)
        print key " = \"" val "\""
}
' "$PALETTE" > "$tmp"

mv "$tmp" "$PALETTE"

echo "$field -> $color"
