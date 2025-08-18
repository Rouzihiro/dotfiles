#!/bin/bash
# Switch dotfiles repository to use SSH

REPO_DIR="$HOME/dotfiles"
REMOTE_NAME="origin"
SSH_URL="git@github.com:Rouzihiro/dotfiles.git"

if [ ! -d "$REPO_DIR/.git" ]; then
    echo "Error: $REPO_DIR is not a Git repository."
    exit 1
fi

cd "$REPO_DIR" || exit 1

CURRENT_URL=$(git remote get-url "$REMOTE_NAME")
if [[ "$CURRENT_URL" == "$SSH_URL" ]]; then
    echo "Remote is already using SSH."
    exit 0
fi

git remote set-url "$REMOTE_NAME" "$SSH_URL"
echo "Remote switched to SSH successfully."
git remote -v

