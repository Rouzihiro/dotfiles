#!/bin/bash

INSTALLER_PATH="$HOME/Scripts/packages.sh"

# Detect distribution
detect_distro() {
    if [ -f /etc/arch-release ]; then
        echo "arch"
    elif [ -f /etc/fedora-release ]; then
        echo "fedora"
    elif [ -f /etc/debian_version ]; then
        echo "debian"
    else
        echo "unknown"
    fi
}

DISTRO=$(detect_distro)

# Main loop
while true; do
    # Common menu items
    common_menu=(
        " List Installed Packages"
        " List Explicitly Installed Packages"
        "󰆴 Uninstall a Package"
        "󰚰 System Update"
        "󰅖 Exit"
    )

    # Arch-specific menu items
    arch_menu=(
        " List Foreign (AUR) Installed Packages"
        "󰜮 Install (Arch Repo)"
        "󰜮 Install (AUR)"
        " Clean Unused Packages"
    )

    # Fedora-specific menu items
    fedora_menu=(
        " List RPM Fusion Packages"
        "󰜮 Install (DNF)"
        "󰜮 Install (Flatpak)"
        " Clean DNF Cache"
    )

    # Build menu based on distribution
    case $DISTRO in
        "arch")
            menu=("${common_menu[@]}" "${arch_menu[@]}")
            ;;
        "fedora")
            menu=("${common_menu[@]}" "${fedora_menu[@]}")
            ;;
        *)
            menu=("${common_menu[@]}")
            notify-send "Package Manager" "Unsupported distribution: $DISTRO"
            ;;
    esac

    selected=$(printf '%s\n' "${menu[@]}" | rofi -dmenu -i -p "Package management ($DISTRO)")

    # Handle exit condition
    if [ -z "$selected" ] || [ "$selected" = "󰅖 Exit" ]; then
        exit 0
    fi

    # Handle selection
    case "$selected" in
        # Common options
        " List Installed Packages")
            killall rofi
            sleep 0.05
            case $DISTRO in
                "arch")
                    PACKAGES=$(pacman -Q | awk '{print "", $1, "|", $2}')
                    echo "$PACKAGES" | rofi -matching fuzzy -dmenu -i -p " Installed Packages (Arch)" -theme "$HOME/.config/rofi/cheatsheet.rasi"
                    ;;
                "fedora")
                    PACKAGES=$(rpm -qa --queryformat '%{NAME} | %{VERSION}-%{RELEASE}\n' | sort | awk '{print "", $0}')
                    echo "$PACKAGES" | rofi -matching fuzzy -dmenu -i -p " Installed Packages (Fedora)" -theme "$HOME/.config/rofi/cheatsheet.rasi"
                    ;;
            esac
            ;;

        " List Explicitly Installed Packages")
            killall rofi
            sleep 0.05
            case $DISTRO in
                "arch")
                    PACKAGES=$(pacman -Qe | awk '{print "", $1, "|", $2}')
                    ;;
                "fedora")
                    PACKAGES=$(dnf list installed | grep -v "Installed Packages" | grep -v "^$" | awk '{print "", $1, "|", $2}')
                    ;;
            esac
            echo "$PACKAGES" | rofi -matching fuzzy -dmenu -i -p " Explicitly Installed Packages" -theme "$HOME/.config/rofi/cheatsheet.rasi"
            ;;

        "󰆴 Uninstall a Package")
            killall rofi
            sleep 0.05
            case $DISTRO in
                "arch")
                    kitty --class floating -e sh -c "
                    echo -e '\033[1;31m=== Uninstall Packages ===\033[0m'
                    '$INSTALLER_PATH' uninstall
                    echo -e '\033[1;32m=== Uninstallation Complete ===\033[0m'
                    echo 'Press enter to continue'
                    read -r
                    "
                    ;;
                "fedora")
                    kitty --class floating -e sh -c "
                    echo -e '\033[1;31m=== Uninstall Packages ===\033[0m'
                    echo 'Available packages:'
                    dnf list installed | tail -n +2
                    echo ''
                    read -p 'Enter package name to remove: ' pkg
                    if [ -n \"\$pkg\" ]; then
                        sudo dnf remove \$pkg
                    else
                        echo 'No package selected'
                    fi
                    echo -e '\033[1;32m=== Uninstallation Complete ===\033[0m'
                    echo 'Press enter to continue'
                    read -r
                    "
                    ;;
            esac
            ;;

        "󰚰 System Update")
            killall rofi
            sleep 0.05
            case $DISTRO in
                "arch")
                    kitty --class floating -e sh -c "
                    echo -e '\033[1;34m=== System Update ===\033[0m'
                    '$HOME/Scripts/system-update.sh'
                    echo -e '\033[1;32m=== Update Complete ===\033[0m'
                    echo 'Press enter to continue'
                    read -r
                    "
                    ;;
                "fedora")
                    kitty --class floating -e sh -c "
                    echo -e '\033[1;34m=== Fedora System Update ===\033[0m'
                    sudo dnf upgrade
                    echo -e '\033[1;32m=== Update Complete ===\033[0m'
                    echo 'Press enter to continue'
                    read -r
                    "
                    ;;
            esac
            ;;

        # Arch-specific options
        " List Foreign (AUR) Installed Packages")
            if [ "$DISTRO" = "arch" ]; then
                killall rofi
                sleep 0.05
                PACKAGES=$(pacman -Qm | awk '{print "", $1, "|", $2}')
                echo "$PACKAGES" | rofi -matching fuzzy -dmenu -i -p " Installed Packages (AUR)" -theme "$HOME/.config/rofi/cheatsheet.rasi"
            fi
            ;;

        "󰜮 Install (Arch Repo)")
            if [ "$DISTRO" = "arch" ]; then
                killall rofi
                sleep 0.05
                kitty --class floating -e sh -c "
                echo -e '\033[1;34m=== Install PACMAN Packages ===\033[0m'
                '$INSTALLER_PATH' install
                echo -e '\033[1;32m=== Installation Complete ===\033[0m'
                echo 'Press enter to continue'
                read -r
                "
            fi
            ;;

        "󰜮 Install (AUR)")
            if [ "$DISTRO" = "arch" ]; then
                killall rofi
                sleep 0.05
                kitty --class floating -e sh -c "
                echo -e '\033[1;33m=== Install AUR Packages ===\033[0m'
                '$INSTALLER_PATH' install aur
                echo -e '\033[1;32m=== Installation Complete ===\033[0m'
                echo 'Press enter to continue'
                read -r
                "
            fi
            ;;

        " Clean Unused Packages")
            if [ "$DISTRO" = "arch" ]; then
                killall rofi
                sleep 0.05
                kitty --class floating -e sh -c "
                echo -e '\033[1;31m=== Clean Orphaned Packages ===\033[0m'
                sudo pacman -Rns \$(pacman -Qdtq)
                echo -e '\033[1;32m=== Cleaning Complete ===\033[0m'
                echo 'Press enter to continue'
                read -r
                "
            fi
            ;;

        # Fedora-specific options
        " List RPM Fusion Packages")
            if [ "$DISTRO" = "fedora" ]; then
                killall rofi
                sleep 0.05
                PACKAGES=$(dnf list installed | grep -i rpmfusion | awk '{print "", $1, "|", $2}')
                echo "$PACKAGES" | rofi -matching fuzzy -dmenu -i -p " RPM Fusion Packages" -theme "$HOME/.config/rofi/cheatsheet.rasi"
            fi
            ;;

        "󰜮 Install (DNF)")
            if [ "$DISTRO" = "fedora" ]; then
                killall rofi
                sleep 0.05
                kitty --class floating -e sh -c "
                echo -e '\033[1;34m=== Install DNF Packages ===\033[0m'
                echo 'Searching for available packages...'
                read -p 'Enter package name to install: ' pkg
                if [ -n \"\$pkg\" ]; then
                    sudo dnf install \$pkg
                else
                    echo 'No package selected'
                fi
                echo -e '\033[1;32m=== Installation Complete ===\033[0m'
                echo 'Press enter to continue'
                read -r
                "
            fi
            ;;

        "󰜮 Install (Flatpak)")
            if [ "$DISTRO" = "fedora" ]; then
                killall rofi
                sleep 0.05
                kitty --class floating -e sh -c "
                echo -e '\033[1;34m=== Install Flatpak Apps ===\033[0m'
                echo 'Available Flatpak apps:'
                flatpak remote-ls --app --columns=application,name
                echo ''
                read -p 'Enter Flatpak app ID to install: ' app
                if [ -n \"\$app\" ]; then
                    flatpak install \$app
                else
                    echo 'No app selected'
                fi
                echo -e '\033[1;32m=== Installation Complete ===\033[0m'
                echo 'Press enter to continue'
                read -r
                "
            fi
            ;;

        " Clean DNF Cache")
            if [ "$DISTRO" = "fedora" ]; then
                killall rofi
                sleep 0.05
                kitty --class floating -e sh -c "
                echo -e '\033[1;31m=== Clean DNF Cache ===\033[0m'
                sudo dnf clean all
                echo -e '\033[1;32m=== Cache Cleaning Complete ===\033[0m'
                echo 'Press enter to continue'
                read -r
                "
            fi
            ;;
    esac

    # Small delay before showing menu again
    sleep 0.1
done
