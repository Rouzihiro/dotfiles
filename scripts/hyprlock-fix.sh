#!/bin/bash
set -e

echo "🔐 Fixing /etc/pam.d/hyprlock..."

sudo bash -c 'cat > /etc/pam.d/hyprlock <<EOF
# PAM configuration file for hyprlock
auth        include     login
account     include     login
password    include     login
session     include     login
EOF'

echo "✅ /etc/pam.d/hyprlock has been updated."
echo "You can now test Hyprlock unlocking properly."

