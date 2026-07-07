#!/bin/bash
# bootstrap.sh
#
# Entry point for setting up this dotfiles repo on a fresh machine.
# Detects distro, installs git/zsh/fzf/xdg-user-dirs if needed, clones
# (or reuses) the dotfiles repo, then dispatches to fedora/install-fedora.sh,
# arch/install-arch.sh, debian/install-debian.sh, or void/install-void.sh
# based on the detected (or fzf-selected) distro.

# --- Detect Distro ---
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        case "$ID" in
            arch|endeavouros|garuda|manjaro)
                echo "arch"
                ;;
            fedora|fedora-asahi-remix|risi|nobara|ultramarine)
                echo "fedora"
                ;;
            debian|ubuntu|raspbian|linuxmint|pop|elementary|zorin|kali|neon)
                echo "debian"
                ;;
            void)
                echo "void"
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

# --- Install bootstrap-stage dependencies (git, zsh, fzf, xdg-user-dirs) ---
if [ "$DISTRO" = "arch" ]; then
    if ! command -v git >/dev/null || ! command -v zsh >/dev/null || ! command -v fzf >/dev/null || ! pacman -Qi xdg-user-dirs >/dev/null 2>/dev/null; then
        echo "Installing required packages (Arch)..."
        sudo pacman -Sy --noconfirm git zsh fzf xdg-user-dirs
    fi
elif [ "$DISTRO" = "fedora" ]; then
    if ! command -v git >/dev/null || ! command -v zsh >/dev/null || ! command -v fzf >/dev/null || ! rpm -q xdg-user-dirs >/dev/null 2>/dev/null; then
        echo "Installing required packages (Fedora)..."
        sudo dnf install -y git zsh fzf xdg-user-dirs
    fi
elif [ "$DISTRO" = "debian" ]; then
    if ! command -v git >/dev/null || ! command -v zsh >/dev/null || ! command -v fzf >/dev/null || ! dpkg -s xdg-user-dirs >/dev/null 2>/dev/null; then
        echo "Installing required packages (Debian)..."
        sudo apt-get update
        sudo apt-get install -y git zsh fzf xdg-user-dirs
    fi
elif [ "$DISTRO" = "void" ]; then
    if ! command -v git >/dev/null || ! command -v zsh >/dev/null || ! command -v fzf >/dev/null || ! xbps-query xdg-user-dirs >/dev/null 2>/dev/null; then
        echo "Installing required packages (Void)..."
        sudo xbps-install -Sy git zsh fzf xdg-user-dirs
    fi
else
    echo "⚠️  Could not detect Arch, Fedora, Debian, or Void automatically."
    echo "You'll be prompted to choose manually, and you'll need git, zsh, and fzf installed."
fi

# --- Prepare user dirs ---
echo "Preparing user directories..."
sleep 1
xdg-user-dirs-update
clear

# --- Handle dotfiles clone ---
if [ -d "$HOME/dotfiles" ]; then
    echo "📁 Existing dotfiles repository found at ~/dotfiles."
    RECLONE_CHOICE=$(printf 'Keep existing\nRe-clone (overwrite)' | fzf --prompt="Existing dotfiles found > " --height=10 --reverse)
    case "$RECLONE_CHOICE" in
        "Re-clone (overwrite)")
            echo "Re-cloning repository..."
            rm -rf "$HOME/dotfiles"
            git clone https://github.com/Rouzihiro/dotfiles.git "$HOME/dotfiles" || { echo "Clone failed!"; exit 1; }
            ;;
        *)
            echo "Skipping clone. Using existing ~/dotfiles."
            ;;
    esac
else
    CLONE_CHOICE=$(printf 'Clone now\nSkip' | fzf --prompt="Clone dotfiles repository? > " --height=10 --reverse)
    case "$CLONE_CHOICE" in
        "Skip")
            echo "Skipping clone step. Continuing..."
            ;;
        *)
            echo "Cloning dotfiles repository..."
            git clone https://github.com/Rouzihiro/dotfiles.git "$HOME/dotfiles" || { echo "Clone failed!"; exit 1; }
            ;;
    esac
fi

# --- Submodules (selectable) ---
if [ -d "$HOME/dotfiles/.git" ]; then
    cd "$HOME/dotfiles" || exit 1

    if git submodule status >/dev/null 2>&1 && [ -f "$HOME/dotfiles/.gitmodules" ]; then
        SUBMODULE_CHOICE=$(printf 'Update submodules\nSkip' | fzf --prompt="Submodules detected > " --height=10 --reverse)
        if [ "$SUBMODULE_CHOICE" = "Update submodules" ]; then
            echo "Updating submodules..."
            git submodule update --init --recursive --remote
        else
            echo "Skipping submodule update."
        fi
    fi
fi

clear
echo "✅ Dotfiles ready!"
sleep 1

# --- Dispatch to the matching distro installer ---
dispatch_installer() {
    local target="$1"
    case "$target" in
        arch)
            echo "Launching install-arch.sh ..."
            sleep 1
            if [ -f "$HOME/dotfiles/install/arch/install-arch.sh" ]; then
                bash "$HOME/dotfiles/install/arch/install-arch.sh"
            else
                echo "arch/install-arch.sh not found."
            fi
            ;;
        fedora)
            echo "Launching install-fedora.sh ..."
            sleep 1
            if [ -f "$HOME/dotfiles/install/fedora/install-fedora.sh" ]; then
                bash "$HOME/dotfiles/install/fedora/install-fedora.sh"
            else
                echo "install/fedora/install-fedora.sh not found."
            fi
            ;;
        debian)
            echo "Launching install-debian.sh ..."
            sleep 1
            if [ -f "$HOME/dotfiles/install/debian/install-debian.sh" ]; then
                bash "$HOME/dotfiles/install/debian/install-debian.sh"
            else
                echo "install/debian/install-debian.sh not found."
            fi
            ;;
        void)
            echo "Launching install-void.sh ..."
            sleep 1
            if [ -f "$HOME/dotfiles/install/void/install-void.sh" ]; then
                bash "$HOME/dotfiles/install/void/install-void.sh"
            else
                echo "install/void/install-void.sh not found."
            fi
            ;;
        *)
            echo "Skipping installer. Run manually later if needed."
            ;;
    esac
}

if [ -d "$HOME/dotfiles" ]; then
    case "$DISTRO" in
        arch|fedora|debian|void)
            echo "Detected: $DISTRO"
            dispatch_installer "$DISTRO"
            ;;
        *)
            if command -v fzf >/dev/null; then
                CHOICE=$(printf 'Arch Linux\nFedora\nDebian\nVoid Linux\nSkip installation' | fzf --prompt="Which installer? > " --height=10 --reverse)
                case "$CHOICE" in
                    "Arch Linux")  dispatch_installer "arch" ;;
                    "Fedora")      dispatch_installer "fedora" ;;
                    "Debian")      dispatch_installer "debian" ;;
                    "Void Linux")  dispatch_installer "void" ;;
                    *)             echo "Skipping installer. Run manually later if needed." ;;
                esac
            else
                echo "fzf not available — cannot prompt for distro choice. Run install-fedora.sh, install-arch.sh, install-debian.sh, or install-void.sh manually."
            fi
            ;;
    esac
else
    echo "~/dotfiles not present — cannot continue."
    exit 1
fi
