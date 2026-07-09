#!/bin/bash

# -----------------------------
# Configuration
# -----------------------------
REPO="git@github.com:Rouzihiro/dotfiles.git"
SSH_KEY="$HOME/.ssh/id_github"

# -----------------------------
# 1. Switch repo to SSH
# -----------------------------
git remote set-url origin "$REPO"

echo "Remote updated to SSH:"
git remote -v

# -----------------------------
# 2. Load SSH key if needed
# -----------------------------
if ! ssh-add -l | grep -q "$(ssh-keygen -lf "$SSH_KEY" | awk '{print $2}')"; then
    echo "Adding GitHub SSH key..."
    ssh-add "$SSH_KEY"
else
    echo "GitHub SSH key already loaded."
fi

# -----------------------------
# 3. Test SSH connection
# -----------------------------
echo "Testing SSH connection to GitHub..."

ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"

if [ $? -eq 0 ]; then
    echo "SSH authentication successful."
else
    echo "SSH authentication failed."
    exit 1
fi
