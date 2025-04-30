#!/bin/bash
# 💫 https://github.com/JaKooLit 💫 #
# SDDM themes #

source_theme="https://codeberg.org/JaKooLit/sddm-sequoia"
theme_name="sequoia_2"

## WARNING: DO NOT EDIT BEYOND THIS LINE IF YOU DON'T KNOW WHAT YOU ARE DOING! ##
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PARENT_DIR="$SCRIPT_DIR/.."
cd "$PARENT_DIR" || { echo "${ERROR} Failed to change directory to $PARENT_DIR"; exit 1; }

# Source the global functions script
if ! source "$(dirname "$(readlink -f "$0")")/Global_functions.sh"; then
  echo "Failed to source Global_functions.sh"
  exit 1
fi

LOG="Install-Logs/install-$(date +%d-%H%M%S)_sddm_theme.log"

# Install the SDDM theme
printf "${INFO} Installing ${SKY_BLUE}Additional SDDM Theme${RESET}\n"

# Remove existing theme if it exists
if [ -d "/usr/share/sddm/themes/$theme_name" ]; then
  sudo rm -rf "/usr/share/sddm/themes/$theme_name"
  echo -e "\e[1A\e[K${OK} - Removed existing $theme_name directory." 2>&1 | tee -a "$LOG"
fi

if [ -d "$theme_name" ]; then
  rm -rf "$theme_name"
  echo -e "\e[1A\e[K${OK} - Removed existing $theme_name directory from the current location." 2>&1 | tee -a "$LOG"
fi

# Clone the theme
if git clone --depth=1 "$source_theme" "$theme_name"; then
  if [ ! -d "$theme_name" ]; then
    echo "${ERROR} Failed to clone the repository." | tee -a "$LOG"
    exit 1
  fi

  # Ensure theme directory exists
  if [ ! -d "/usr/share/sddm/themes" ]; then
    sudo mkdir -p /usr/share/sddm/themes
    echo "${OK} - Directory '/usr/share/sddm/themes' created." | tee -a "$LOG"
  fi

  sudo mv "$theme_name" "/usr/share/sddm/themes/$theme_name" 2>&1 | tee -a "$LOG"

  # Configure SDDM theme
  sddm_conf_dir="/etc/sddm.conf.d"
  BACKUP_SUFFIX=".bak"

  echo -e "${NOTE} Setting up the login screen." | tee -a "$LOG"

  if [ -d "$sddm_conf_dir" ]; then
    echo "Backing up files in $sddm_conf_dir" | tee -a "$LOG"
    for file in "$sddm_conf_dir"/*; do
      if [ -f "$file" ]; then
        if [[ "$file" == *$BACKUP_SUFFIX ]]; then
          echo "Skipping backup file: $file" | tee -a "$LOG"
          continue
        fi
        sudo cp "$file" "$file$BACKUP_SUFFIX" 2>&1 | tee -a "$LOG"
        echo "Backup created for $file" | tee -a "$LOG"
        if grep -q '^[[:space:]]*Current=' "$file"; then
          sudo sed -i "s/^[[:space:]]*Current=.*/Current=$theme_name/" "$file" 2>&1 | tee -a "$LOG"
          echo "Updated theme in $file" | tee -a "$LOG"
        fi
      fi
    done
  else
    echo "$CAT - $sddm_conf_dir not found, creating..." | tee -a "$LOG"
    sudo mkdir -p "$sddm_conf_dir" 2>&1 | tee -a "$LOG"
  fi

  # Create default theme conf if needed
  if [ ! -f "$sddm_conf_dir/theme.conf.user" ]; then
    echo -e "[Theme]\nCurrent = $theme_name" | sudo tee "$sddm_conf_dir/theme.conf.user" > /dev/null
    if [ -f "$sddm_conf_dir/theme.conf.user" ]; then
      echo "Created and configured $sddm_conf_dir/theme.conf.user with theme $theme_name" | tee -a "$LOG"
    else
      echo "Failed to create $sddm_conf_dir/theme.conf.user" | tee -a "$LOG"
    fi
  else
    echo "ℹ️  $sddm_conf_dir/theme.conf.user already exists, skipping creation." | tee -a "$LOG"
  fi

  # Replace theme background image
  custom_image_path="$(eval echo ~"$USER")/dotfiles/assets/sddm.png"
  target_image_path="/usr/share/sddm/themes/$theme_name/backgrounds/default"

  if [ -f "$custom_image_path" ]; then
    sudo cp "$custom_image_path" "$target_image_path" 2>&1 | tee -a "$LOG"
    sudo sed -i 's|^wallpaper=".*"|wallpaper="backgrounds/default"|' "/usr/share/sddm/themes/$theme_name/theme.conf" 2>&1 | tee -a "$LOG"
    echo "🖼️  Custom SDDM background applied from $custom_image_path" | tee -a "$LOG"
  else
    echo "❌ Custom image not found at $custom_image_path" | tee -a "$LOG"
  fi

  echo -e "${OK} - ${MAGENTA}Additional SDDM Theme${RESET} successfully installed." | tee -a "$LOG"

else
  echo "${ERROR} - Failed to clone the sddm theme repository. Please check your internet connection." | tee -a "$LOG" >&2
fi

# Final line break
printf "\n%.0s" {1..2}

