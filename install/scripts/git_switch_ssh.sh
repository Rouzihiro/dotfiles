#!/bin/bash

# -----------------------------
# Configuration
# -----------------------------
REPO="git@github.com:Rouzihiro/dotfiles.git"

# -----------------------------
# 1. Switch repo to SSH
# -----------------------------
git remote set-url origin "$REPO"
echo "Remote updated to SSH:"
git remote -v

# -----------------------------
# 2. Test SSH connection
# -----------------------------
echo "Testing SSH connection to GitHub..."
ssh -T git@github.com

