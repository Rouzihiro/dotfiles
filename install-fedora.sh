#!/bin/bash

set -e

echo "[*] Updating system..."
sudo dnf update -y

echo "[*] Enabling RPM Fusion repositories..."
sudo dnf install -y \
  "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
  "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"

echo "[*] Installing packages..."
sudo dnf install -y \
  hyprland waybar hypridle hyprlock \
  asahi-desktop-meta asahi-meta \
  power-profiles-daemon swaync rofi wayland-utils btop \
  zsh foot starship eza bat fzf duf ncdu tree tmux fastfetch \
  aria2 grim slurp brightnessctl mediainfo jq bc trash-cli unzip \
  ntfs-3g highlight blueman curlftpfs vifm thunar xdg-user-dirs yad rsync swappy \
  hunspell-de tesseract tesseract-langpack-eng tesseract-langpack-deu \
  ffmpegthumbs ImageMagick imv vlc yt-dlp pamixer \
  lazygit git-delta jdk-openjdk nodejs npm texlive-latexextra texmaker \
  mesa-demos vulkan-tools \
  fontawesome-fonts google-droid-sans-fonts fira-code-fonts \
  fantasque-sans-mono-fonts jetbrains-mono-fonts \
  fira-code-nerd-fonts hack-nerd-fonts cascadia-code-nerd-fonts \
  dejavu-sans-fonts google-noto-sans-fonts \
  zathura zathura-cb zathura-pdf-mupdf neovim swww

echo "[*] Cleaning up..."
sudo dnf autoremove -y
sudo dnf clean all

echo "[✓] Done. Reboot to apply all changes."

