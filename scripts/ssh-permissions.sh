#!/bin/sh

# Set permissions for the private key
chmod 600 ~/.ssh/HP-Nixo

# Set permissions for the public key
chmod 644 ~/.ssh/HP-Nixo.pub

# Set permissions for the known_hosts file
chmod 644 ~/.ssh/known_hosts

# Set permissions for the environment file
chmod 644 ~/.ssh/environment

chmod 600 ~/.ftp_credentials

# Verify the permissions
echo "Permissions set. Verifying:"
ls -l ~/.ssh/HP-Nixo ~/.ssh/HP-Nixo.pub ~/.ssh/known_hosts ~/.ssh/environment ~/.ssh/ftp_credentials ~/.ssh/email_secrets/


# Ensure You're Using SSH for Git Operations
# Your repository is currently using HTTPS for the remote URL. You need to switch it to SSH.
#
# Check the current remote URL:
#
# git remote -v
# This will show something like:
#
# origin  https://github.com/Rouzihiro/dotfiles.git (fetch)
# origin  https://github.com/Rouzihiro/dotfiles.git (push)
# Change the remote URL to use SSH:
#
# git remote set-url origin git@github.com:Rouzihiro/dotfiles.git
# Verify the change:
#
# git remote -v
# It should now show:
#
# origin  git@github.com:Rouzihiro/dotfiles.git (fetch)
# origin  git@github.com:Rouzihiro/dotfiles.git (push)
#
#  git config --global user.email "ryossj@gmail.com"
#  git config --global user.name "Rouzihiro"
