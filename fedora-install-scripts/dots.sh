#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

essentials=(
# Terminal and shell
starship
zsh
foot
bat
fzf
fd
duf
ncdu
tree
tmux
fastfetch
highlight

# File management
gdisk
parted
exfatprogs
ntfs-3g

# Utilities
aria2
grim
slurp
brightnessctl
mediainfo
jq
bc
trash-cli
unzip
poppler-utils
sxiv
ffmpegthumbnailer
blueman
curlftpfs
thunar
xdg-user-dirs
yad
rsync
swappy
antimicrox
)

## WARNING: DO NOT EDIT BEYOND THIS LINE IF YOU DON'T KNOW WHAT YOU ARE DOING! ##
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change the working directory to the parent directory of the script
PARENT_DIR="$SCRIPT_DIR/.."
cd "$PARENT_DIR" || { echo "${ERROR} Failed to change directory to $PARENT_DIR"; exit 1; }

# Source the global functions script
if ! source "$(dirname "$(readlink -f "$0")")/Global_functions.sh"; then
  echo "Failed to source Global_functions.sh"
  exit 1
fi


# Create Directory for Install Logs
if [ ! -d Install-Logs ]; then
    mkdir Install-Logs
fi

# Set the name of the log file to include the current date and time
LOG="Install-Logs/install-$(date +%d-%H%M%S)_essentials.log"

printf "${NOTE} Installing ${SKY_BLUE}essential packages${RESET} .......\n"
for pkg in "${essentials[@]}"; do
  install_package "$pkg" "$LOG"
done

printf "\n%.0s" {1..2}
