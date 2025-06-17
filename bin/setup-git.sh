#!/bin/sh

# Set Git user information globally
git config --global user.name "Rouzihiro"
git config --global user.email "ryossj@gmail.com"

# Optional: Show confirmation
echo "✅ Git global identity set:"
git config --global --list
