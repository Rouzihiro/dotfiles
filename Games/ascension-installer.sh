#!/bin/bash
set -e

# ========= CONFIG =========
GAME_NAME="ascension-wow"
PREFIX_DIR="$HOME/Games/$GAME_NAME"
INSTALLER_URL="https://api.ascension.gg/api/bootstrap/launcher/latest"
INSTALLER_NAME="AscensionLauncher.exe"
INSTALL_DIR="$PREFIX_DIR/drive_c/AscensionInstaller"
EXE_PATH="$PREFIX_DIR/drive_c/Program Files/Ascension Launcher/Ascension Launcher.exe"

# ========= FUNCTIONS =========

function install_dependencies() {
  echo "[+] Installing required packages via pacman..."
  sudo pacman -S --needed \
    wine winetricks cabextract \
    lib32-gnutls lib32-mpg123 lib32-openal \
    lib32-v4l-utils lib32-libpulse lib32-vulkan-icd-loader \
    wget unzip
}

function create_wine_prefix() {
  echo "[+] Creating Wine prefix at $PREFIX_DIR"
  export WINEARCH=win64
  export WINEPREFIX="$PREFIX_DIR"
  wineboot
}

function install_winetricks_deps() {
  echo "[+] Installing Winetricks dependencies..."
  export WINEPREFIX="$PREFIX_DIR"
  winetricks -q win10 ie8 corefonts dotnet48 vcrun2015 || {
    echo "[!] Winetricks failed. Try removing -q to debug interactively."
  }
}

function download_launcher() {
  echo "[+] Downloading Ascension Launcher..."
  mkdir -p "$INSTALL_DIR"
  cd "$INSTALL_DIR"
  wget "$INSTALLER_URL" -O "$INSTALLER_NAME"
}

function run_launcher_installer() {
  echo "[+] Running Ascension Launcher installer..."
  export WINEPREFIX="$PREFIX_DIR"
  wine "$INSTALL_DIR/$INSTALLER_NAME"
}

function print_run_instruction() {
  echo ""
  echo "[✓] Installation complete!"
  echo "To launch Ascension WoW, run:"
  echo ""
  echo "  WINEPREFIX=\"$PREFIX_DIR\" wine \"$EXE_PATH\""
  echo ""
}

# ========= MAIN =========

echo "== Project Ascension WoW Installer =="

install_dependencies
create_wine_prefix
install_winetricks_deps
download_launcher
run_launcher_installer
print_run_instruction

