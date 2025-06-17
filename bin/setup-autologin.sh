#!/bin/bash

USER_NAME="rey"
TTY="tty1"
SERVICE="getty@${TTY}"

echo "🔧 Setting up autologin for user: $USER_NAME on $TTY..."

# Create systemd override directory
sudo mkdir -p /etc/systemd/system/${SERVICE}.service.d

# Write the override configuration
sudo tee /etc/systemd/system/${SERVICE}.service.d/override.conf > /dev/null <<EOF
[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --autologin ${USER_NAME} --noclear %I \$TERM
EOF

# Reload systemd and enable the service
sudo systemctl daemon-reexec
sudo systemctl enable ${SERVICE}

echo "✅ Autologin setup complete for user '$USER_NAME' on ${TTY}."

