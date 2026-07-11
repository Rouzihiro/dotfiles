#!/bin/sh

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
DASHBOARD_DIR="$(dirname "$SCRIPT_DIR")"

OUTPUT="$DASHBOARD_DIR/data/git-tree.txt"
REPO="$HOME/dotfiles"

mkdir -p "$(dirname "$OUTPUT")"

cd "$REPO" || exit 1


CHANGES=$(git status --short)


if [ -z "$CHANGES" ]; then

    cat > "$OUTPUT" <<EOF
󰊢 DOTFILES

✓ Working tree clean

Nothing to commit.
EOF

    exit 0

fi


TMP=$(mktemp)

printf "%s\n" "$CHANGES" | awk '{print $2}' > "$TMP"


{
    echo "󰊢 DOTFILES CHANGES"
    echo ""

    tree --fromfile < "$TMP"

    echo ""
    echo "----------------"
    echo ""

    printf "%s\n" "$CHANGES"

} > "$OUTPUT"


rm "$TMP"
