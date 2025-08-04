#!/bin/bash

# Define the groups to be added
groups=("scanner" "wheel" "audio" "input" "lp" "storage" "video" "fuse" "docker")

# User input: specify the username
read -p "Enter the username to add to groups: " username

# Check if the user exists
if ! id "$username" &>/dev/null; then
  echo "User $username does not exist."
  exit 1
fi

# Add groups if they don't exist
for group in "${groups[@]}"; do
  if ! getent group "$group" &>/dev/null; then
    sudo groupadd "$group"
    echo "Group '$group' created."
  else
    echo "Group '$group' already exists."
  fi
done

# Add user to the groups
for group in "${groups[@]}"; do
  sudo usermod -aG "$group" "$username"
  echo "User $username added to group '$group'."
done

# Create udev rule for /dev/uinput
echo "Creating udev rule for /dev/uinput..."
sudo bash -c 'echo "KERNEL==\"uinput\", MODE=\"0660\", GROUP=\"input\"" > /etc/udev/rules.d/99-uinput.rules'

# Reload udev rules
echo "Reloading udev rules..."
sudo udevadm control --reload-rules
sudo udevadm trigger

# Prompt to load uinput module manually
read -p "Do you want to load the uinput module now? (y/N): " answer
if [[ "$answer" =~ ^[Yy]$ ]]; then
  sudo modprobe uinput
  echo "uinput module loaded."
else
  echo "Skipped loading uinput module. You can run 'sudo modprobe uinput' manually later."
fi

echo "Done. Please log out and back in for group changes to take effect."

