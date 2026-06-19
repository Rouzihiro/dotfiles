#!/bin/bash
# Global Functions for Scripts (Fedora + Arch) #

# Create Directory for Install Logs
if [ ! -d Install-Logs ]; then
    mkdir Install-Logs
fi

# Log file
LOG="Install-Logs/install.log"

# Set some colors for output messages
OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
INFO="$(tput setaf 4)[INFO]$(tput sgr0)"
WARN="$(tput setaf 1)[WARN]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
MAGENTA="$(tput setaf 5)"
ORANGE="$(tput setaf 214)"
WARNING="$(tput setaf 1)"
YELLOW="$(tput setaf 3)"
GREEN="$(tput setaf 2)"
BLUE="$(tput setaf 4)"
SKY_BLUE="$(tput setaf 6)"
RESET="$(tput sgr0)"


# Show progress function
show_progress() {
    local pid=$1
    local package_name=$2
    local spin_chars=("●○○○○○○○○○" "○●○○○○○○○○" "○○●○○○○○○○" "○○○●○○○○○○" "○○○○●○○○○" \
                      "○○○○○●○○○○" "○○○○○○●○○○" "○○○○○○○●○○" "○○○○○○○○●○" "○○○○○○○○○●") 
    local i=0

    tput civis 
    printf "\r${INFO} Installing ${YELLOW}%s${RESET} ..." "$package_name"

    while ps -p $pid &> /dev/null; do
        printf "\r${INFO} Installing ${YELLOW}%s${RESET} %s" "$package_name" "${spin_chars[i]}"
        i=$(( (i + 1) % 10 ))  
        sleep 0.3  
    done

    printf "\r${INFO} Installing ${YELLOW}%s${RESET} ... Done!%-20s \n" "$package_name" ""
    tput cnorm  
}

# -------------------------------
# Detect package manager once
# -------------------------------
if command -v dnf &>/dev/null; then
    _PKG_MGR="dnf"
elif command -v pacman &>/dev/null; then
    _PKG_MGR="pacman"
else
    _PKG_MGR="unknown"
fi

# Function to check if a package is installed, regardless of distro
_pkg_is_installed() {
  case "$_PKG_MGR" in
    dnf)    rpm -q "$1" &>/dev/null ;;
    pacman) pacman -Qi "$1" &>/dev/null ;;
    *)      return 1 ;;
  esac
}

# Function to install packages (works on both Fedora/dnf and Arch/pacman)
install_package() {
  if _pkg_is_installed "$1"; then
    echo -e "${INFO} ${MAGENTA}$1${RESET} is already installed. Skipping..."
    return 0
  fi

  case "$_PKG_MGR" in
    dnf)
      ( stdbuf -oL sudo dnf install -y "$1" 2>&1 ) >> "$LOG" 2>&1 &
      ;;
    pacman)
      ( stdbuf -oL sudo pacman -S --needed --noconfirm "$1" 2>&1 ) >> "$LOG" 2>&1 &
      ;;
    *)
      echo -e "${ERROR} No supported package manager found (need dnf or pacman)."
      return 1
      ;;
  esac

  PID=$!
  show_progress $PID "$1"

  if _pkg_is_installed "$1"; then
    echo -e "${OK} Package ${YELLOW}$1${RESET} has been successfully installed!"
  else
    echo -e "\n${ERROR} ${YELLOW}$1${RESET} failed to install. Please check the $LOG. You may need to install manually."
  fi
}

# Function for removing packages (works on both Fedora/dnf and Arch/pacman)
uninstall_package() {
  local pkg="$1"

  if ! _pkg_is_installed "$pkg"; then
    echo -e "${INFO} Package $pkg not installed, skipping."
    return 0
  fi

  echo -e "${NOTE} removing $pkg ..."

  case "$_PKG_MGR" in
    dnf)
      sudo dnf remove -y "$pkg" 2>&1 | tee -a "$LOG" | grep -v "error: target not found"
      ;;
    pacman)
      sudo pacman -Rns --noconfirm "$pkg" 2>&1 | tee -a "$LOG" | grep -v "error: target not found"
      ;;
    *)
      echo -e "${ERROR} No supported package manager found (need dnf or pacman)."
      return 1
      ;;
  esac

  if ! _pkg_is_installed "$pkg"; then
    echo -e "\e[1A\e[K${OK} $pkg removed."
  else
    echo -e "\e[1A\e[K${ERROR} $pkg Removal failed. No actions required."
    return 1
  fi
  return 0
}

# Function to install an AUR package — no-op with a clear message on Fedora,
# uses yay/paru on Arch. Keeping this here (rather than Arch-only) means
# scripts can call it unconditionally without checking distro first.
install_aur_package() {
  if [[ "$_PKG_MGR" != "pacman" ]]; then
    echo -e "${WARN} install_aur_package called on non-Arch system. Skipping $1."
    return 1
  fi

  local helper=""
  if command -v yay &>/dev/null; then
    helper="yay"
  elif command -v paru &>/dev/null; then
    helper="paru"
  else
    echo -e "${WARN} No AUR helper (yay/paru) found. Skipping AUR package $1."
    return 1
  fi

  if _pkg_is_installed "$1"; then
    echo -e "${INFO} ${MAGENTA}$1${RESET} is already installed. Skipping..."
    return 0
  fi

  ( stdbuf -oL "$helper" -S --needed --noconfirm "$1" 2>&1 ) >> "$LOG" 2>&1 &
  PID=$!
  show_progress $PID "$1"

  if _pkg_is_installed "$1"; then
    echo -e "${OK} AUR package ${YELLOW}$1${RESET} has been successfully installed!"
  else
    echo -e "\n${ERROR} ${YELLOW}$1${RESET} failed to install via $helper. Please check the $LOG."
  fi
}
