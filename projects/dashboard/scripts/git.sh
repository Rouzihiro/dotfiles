#!/bin/sh

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
DASHBOARD_DIR="$(dirname "$SCRIPT_DIR")"
DATA_DIR="$DASHBOARD_DIR/data"

mkdir -p "$DATA_DIR"

DATA="$DATA_DIR/git.json"

REPO="$HOME/dotfiles"

if [ -d "$REPO/.git" ]; then
    cd "$REPO" || exit 1

    BRANCH=$(git branch --show-current)
    CHANGES=$(git status --porcelain)

    if [ -z "$CHANGES" ]; then
        STATUS="clean"
    else
        STATUS="modified"
    fi
else
    BRANCH="none"
    STATUS="missing"
fi

cat > "$DATA" <<EOF
{
    "branch": "$BRANCH",
    "status": "$STATUS"
}
EOF
