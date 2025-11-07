#!/bin/bash

# --- Detect Distro ---
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        case "$ID" in
            arch|endeavouros|garuda|manjaro)
                echo "arch"
                ;;
            fedora|risi|nobara|ultramarine)
                echo "fedora"
                ;;
            *)
                echo "unknown"
                ;;
        esac
    else
        echo "unknown"
    fi
}

DISTRO=$(detect_distro)

# --- Install dependencies ---
if [ "$DISTRO" = "arch" ]; then
    if ! command -v git >/dev/null || ! pacman -Qi xdg-user-dirs >/dev/null 2>/dev/null; then
        echo "Installing required packages (Arch)..."
        sudo pacman -Sy --noconfirm git xdg-user-dirs
    fi
elif [ "$DISTRO" = "fedora" ]; then
    if ! command -v git >/dev/null || ! rpm -q xdg-user-dirs >/dev/null 2>/dev/null; then
        echo "Installing required packages (Fedora)..."
        sudo dnf install -y git xdg-user-dirs
    fi
else
    echo "⚠️  Could not detect Arch or Fedora automatically."
    echo "You'll be prompted later to choose manually."
fi

# --- Prepare user dirs ---
echo "Preparing user directories..."
sleep 1
xdg-user-dirs-update
clear

# --- Handle dotfiles clone ---
if [ -d "$HOME/dotfiles" ]; then
    echo "📁 Existing dotfiles repository found at ~/dotfiles."
    read -rp "Do you want to re-clone it (overwrite)? [y/N]: " reclone
    case "$reclone" in
        [yY]*)
            echo "Re-cloning repository..."
            rm -rf "$HOME/dotfiles"
            git clone https://github.com/Rouzihiro/dotfiles.git "$HOME/dotfiles" || { echo "Clone failed!"; exit 1; }
            ;;
        *)
            echo "Skipping clone. Using existing ~/dotfiles."
            ;;
    esac
else
    read -rp "Do you want to clone the dotfiles repository now? [Y/n]: " clone
    case "$clone" in
        [nN]*)
            echo "Skipping clone step. Continuing..."
            ;;
        *)
            echo "Cloning dotfiles repository..."
            git clone https://github.com/Rouzihiro/dotfiles.git "$HOME/dotfiles" || { echo "Clone failed!"; exit 1; }
            ;;
    esac
fi

# --- Update submodules if repo exists ---
if [ -d "$HOME/dotfiles/.git" ]; then
    cd "$HOME/dotfiles" || exit
    echo "Updating submodules..."
    git submodule update --init --recursive --remote
fi

clear
echo "✅ Dotfiles ready!"
sleep 1

# --- Auto-run the matching installer ---
case "$DISTRO" in
    arch)
        echo "Detected Arch Linux — launching ./install-arch.sh ..."
        sleep 1
        [ -x ./install-arch.sh ] && ./install-arch.sh || echo "install-arch.sh not found."
        ;;
    fedora)
        echo "Detected Fedora — launching ./install-fedora.sh ..."
        sleep 1
        [ -x ./install-fedora.sh ] && ./install-fedora.sh || echo "install-fedora.sh not found."
        ;;
    *)
        echo
        echo "Which installer would you like to run?"
        echo "  [1] Arch Linux"
        echo "  [2] Fedora"
        echo "  [s] Skip installation"
        echo
        read -rp "Enter choice [1/2/s]: " choice
        case "$choice" in
            1) ./install-arch.sh ;;
            2) ./install-fedora.sh ;;
            s|S)
                echo "Skipping installer. Run manually later if needed."
                ;;
            *)
                echo "Invalid choice. Exiting."
                ;;
        esac
        ;;
esac
