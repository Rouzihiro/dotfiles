INSTALLER_PATH="$HOME/Scripts/packages.sh"

menu=(
    " List Installed Packages"
    " List Explicitly Installed Packages"
    " List Foreign (AUR) Installed Packages"
    "󰜮 Install (Arch Repo)"
    "󰜮 Install (AUR)"
    "󰆴 Uninstall a Package"
    " Clean Unused Packages"
    "󰚰 System Update"
)

selected=$(printf '%s\n' "${menu[@]}" | rofi -dmenu -i -p "Package management")
PACKAGES_EXPLICIT=$(pacman -Qen)
PACKAGES_AUR=$(pacman -Qm)

# Handle selection
if [ -n "$selected" ]; then
    case "$selected" in
        " List Installed Packages")
            killall rofi
            sleep 0.05
            PACKAGES=$(echo "$(pacman -Q)" | awk -v explicit="$PACKAGES_EXPLICIT" -v aur="$PACKAGES_AUR" '
            BEGIN {
                # Build lookup tables for explicit and AUR packages
                split(explicit, explicit_array, "\n")
                for (i in explicit_array) {
                    split(explicit_array[i], parts, " ")
                    explicit_pkgs[parts[1]] = 1
                }
                
                split(aur, aur_array, "\n")
                for (i in aur_array) {
                    split(aur_array[i], parts, " ")
                    aur_pkgs[parts[1]] = 1
                }
            }
            {
                name = $1
                version = $2
                if (name in explicit_pkgs) {
                    icon = ""
                } else if (name in aur_pkgs) {
                    icon = ""
                } else {
                    icon = ""
                }
                print icon, name, "|", version
            }')
            echo "$PACKAGES" | rofi -matching fuzzy -dmenu -i -p " Installed Packages ( Explicit |  AUR |  Dependencies)" -theme "$HOME/.config/rofi/cheatsheet.rasi"
            ;;
        " List Explicitly Installed Packages")
            killall rofi
            sleep 0.05
            PACKAGES=$(echo "$PACKAGES_EXPLICIT" | awk '
            {
                name = $1
                version = $2
                print "", name, "|", version
            }')
            echo "$PACKAGES" | rofi -matching fuzzy -dmenu -i -p " Installed Packages (Explicit)" -theme "$HOME/.config/rofi/cheatsheet.rasi"
            ;;
        " List Foreign (AUR) Installed Packages")
            killall rofi
            sleep 0.05
            PACKAGES=$(echo "$PACKAGES_AUR" | awk '
            {
                name = $1
                version = $2
                print "", name, "|", version
            }')
            echo "$PACKAGES" | rofi -matching fuzzy -dmenu -i -p " Installed Packages (AUR)" -theme "$HOME/.config/rofi/cheatsheet.rasi"
            ;;
        "󰜮 Install (Arch Repo)")
            killall rofi
            sleep 0.05
            kitty --class floating -e sh -c 'echo -e "\e[34m$(figlet -f ansi-shadow \"Installer PACMAN\")\e[0m"; '"$INSTALLER_PATH"' install; echo -e "\e[34m$(figlet -f ansi-shadow \"Done\")\e[0m"; echo "Installation complete, press enter to continue"; read -r; exit 0'
            ;;
        "󰜮 Install (AUR)")
            killall rofi
            sleep 0.05
            kitty --class floating -e sh -c 'echo -e "\e[34m$(figlet -f ansi-shadow \"Installer AUR\")\e[0m"; '"$INSTALLER_PATH"' install aur; echo -e "\e[34m$(figlet -f ansi-shadow \"Done\")\e[0m"; echo "Installation complete, press enter to continue"; read -r; exit 0'
            ;;
        "󰆴 Uninstall a Package")
            killall rofi
            sleep 0.05
            kitty --class floating -e sh -c 'echo -e "\e[34m$(figlet -f ansi-shadow \"Uninstall\")\e[0m"; '"$INSTALLER_PATH"' uninstall; echo -e "\e[34m$(figlet -f ansi-shadow \"Done\")\e[0m"; echo "Uninstallation complete, press enter to continue"; read -r; exit 0'
            ;;
        " Clean Unused Packages")
            killall rofi
            sleep 0.05
            kitty --class floating -e sh -c 'echo -e "\e[34m$(figlet -f ansi-shadow \"Clean\")\e[0m"; sudo pacman -Rns $(pacman -Qdtq); echo -e "\e[34m$(figlet -f ansi-shadow \"Done\")\e[0m"; echo "Cleaning complete, press enter to continue"; read -r; exit 0'
            ;;
        "󰚰 System Update")
            killall rofi
            sleep 0.05
            kitty --class floating -e sh -c "$HOME/Scripts/system-update.sh; echo System update complete, press enter to continue; read -r; exit 0"
            ;;
    esac
fi