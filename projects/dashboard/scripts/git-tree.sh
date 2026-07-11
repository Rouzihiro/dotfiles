#!/bin/sh

OUTPUT="$HOME/dashboard/data/git-tree.txt"

cd "$HOME/dotfiles" || exit 1


TMP=$(mktemp)


git status --short | awk '{print $2}' > "$TMP"


{
echo "󰊢 DOTFILES CHANGES"
echo ""

tree --fromfile < "$TMP"

echo ""
echo "----------------"
echo ""

git status --short

} > "$OUTPUT"


rm "$TMP"
