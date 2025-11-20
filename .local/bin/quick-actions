#!/usr/bin/env bash

main_menu() {
    menu=(
        " Keybinds"
        "󰅇 Clipboard"
        " Coding"
        "󰒓 Theme"
        "󰍛 Hardware"
        " Packages"
        "󰈙 Documents"
        "󰇧 Internet"
        "󰎁 Multimedia"
        "󰘚 Utilities"
 				" Calculator"
				" VPN"
        "󰩛 Exit"
    )

    # Show rofi menu
    selected=$(printf '%s\n' "${menu[@]}" | rofi -dmenu -i -p "Quick Actions" -theme ~/.config/rofi/quick-actions.rasi)

    # Handle selection (empty string means ESC was pressed)
    if [ -z "$selected" ]; then
        exit 0  # ESC from main menu exits completely
    elif [ -n "$selected" ]; then
        case "$selected" in
            "󰅇 Clipboard")
                clipse-gui
                ;;
            " Coding")
                coding_menu
                ;;
            "󰒓 Theme")
                theme_menu
                ;;
            "󰍛 Hardware")
                hardware_menu
                ;;
            " VPN")
                ~/.config/waybar/scripts/tailscale.sh
                ;;
            " Packages")
                packages_menu                 
								;;
            " Keybinds")
                keybinds_menu
                ;;
            " Calculator")
                rofi -show calc -modi calc -no-show-match -no-sort
                ;;
            "󰈙 Documents")
                documents_menu
                ;;
            "󰇧 Internet")
                internet_menu
                ;;
            "󰎁 Multimedia")
                multimedia_menu
                ;;
            "󰘚 Utilities")
                utilities_menu
                ;;
            "󰩛 Exit")
                exit 0
                ;;
        esac
        
        # Loop back to main menu after action (unless user exited)
        if [ "$selected" != "󰩛 Exit" ]; then
            main_menu
        fi
    fi
}

packages_menu() {
    packages_menu=(
	" Zorro Package Installer"
	" Package Installer"
        "󰁍 Back to Main"
    )
    
    packages_selected=$(printf '%s\n' "${packages_menu[@]}" | rofi -dmenu -i -p "Packages" -theme ~/.config/rofi/quick-actions.rasi)
    if [ -z "$packages_selected" ]; then
        main_menu
        return
    fi
    
    case "$packages_selected" in
			" Zorro Package Installer")
				foot -e bash -c "z-pkg-install; exec bash"
            ;;
			" Package Installer")
	 		"z-pkg-install-lite"
            ;;
        "󰁍 Back to Main")
            main_menu
            return
            ;;
    esac
    packages_menu
}

coding_menu() {
    coding_menu=(
			" Shell Scripts (PATH)"
			" Zorro File Manager"
			" Zorro Scripts"
			" Dotfiles Scripts"
        "󰁍 Back to Main"
    )
    
    coding_selected=$(printf '%s\n' "${coding_menu[@]}" | rofi -dmenu -i -p "Coding" -theme ~/.config/rofi/quick-actions.rasi)
    if [ -z "$coding_selected" ]; then
        main_menu
        return
    fi
    
    case "$coding_selected" in
			" Shell Scripts (PATH)")
				rofi-scripts
            ;;
			" Zorro File Manager")
			foot -e bash -c "superb; exec bash"
            ;;
			" Dotfiles Scripts")
			foot -e bash -c "dotfiles-scripts; exec bash"
            ;;
			" Zorro Scripts")
			foot -e bash -c "zorro-scripts; exec bash"
            ;;
        "󰁍 Back to Main")
            main_menu
            return
            ;;
    esac
    coding_menu
}


keybinds_menu() {
    # Keybinds submenu
    kb_menu=(
        " Sway Keybinds"
        " Sway Keybinds 2"
        " Hyprland Keybinds"
        " ZSH Keybinds"
				" Cheats"
        "󰁍 Back to Main"
    )
    
    kb_selected=$(printf '%s\n' "${kb_menu[@]}" | rofi -dmenu -i -p "Keybinds" -theme ~/.config/rofi/quick-actions.rasi)
    
    # Handle ESC key (empty selection)
    if [ -z "$kb_selected" ]; then
        main_menu
        return
    fi
    
    case "$kb_selected" in
        " Sway Keybinds")
            cheatsheet-sway
            ;;
        " Sway Keybinds 2")
            "$HOME/.local/bin/zorro/z-menu-keybindings-sway-soft"
            ;;
        " Hyprland Keybinds")
						cheatsheet-hypr
            ;;
        " ZSH Keybinds")
            notify-send "Keybinds" "ZSH keybinds not configured yet"
            ;;
  			" Cheats")
					foot -e bash -c "cheats; exec bash"
            ;;
        "󰁍 Back to Main")
            main_menu
            return
            ;;
    esac
    
    # Loop back to keybinds menu unless going back to main
    keybinds_menu
}

theme_menu() {
    # Theme submenu
    theme_menu=(
        " Wallpaper"
        "󰞅 Emojis"
        " Icons"
        "󰝰 GTK-Theme-Installer"
        "🎨 Theme Switcher"
        "󰁍 Back to Main"
    )
    
    theme_selected=$(printf '%s\n' "${theme_menu[@]}" | rofi -dmenu -i -p "Theme" -theme ~/.config/rofi/quick-actions.rasi)
    
    # Handle ESC key (empty selection)
    if [ -z "$theme_selected" ]; then
        main_menu
        return
    fi
    
    case "$theme_selected" in
        " Wallpaper")
            rofi-wall
            ;;
        "󰞅 Emojis")
            rofi -show emoji -theme ~/.config/rofi/config.rasi
            ;;
        " Icons")
            ~/.config/waybar/scripts/icon-picker.sh
            ;;
        "󰝰 GTK-Theme-Installer")
            z-theme-set-gtk
            ;;
        "🎨 Theme Switcher")
            rofi-theme-set
            ;;
        "󰁍 Back to Main")
            main_menu
            return
            ;;
    esac
    
    # Loop back to theme menu unless going back to main
    theme_menu
}

hardware_menu() {
    # Hardware submenu
    hardware_menu=(
        "󰁹 Power"
        " Bluetooth"
        "󰖩 WiFi"
        "󰂰 Power Profile"
        "󰕾 Sound"
        "󰁍 Back to Main"
    )
    
    hardware_selected=$(printf '%s\n' "${hardware_menu[@]}" | rofi -dmenu -i -p "Hardware" -theme ~/.config/rofi/quick-actions.rasi)
    
    # Handle ESC key (empty selection)
    if [ -z "$hardware_selected" ]; then
        main_menu
        return
    fi
    
    case "$hardware_selected" in
        "󰁹 Power")
            rofi-power
            ;;
        " Bluetooth")
            rofi-bluetooth
            ;;
        "󰖩 WiFi")
            rofi-wifi
            ;;
        "󰂰 Power Profile")
            rofi-power-profile
            ;;
        "󰕾 Sound")
            ~/.config/waybar/scripts/rofi-audio.sh
            ;;
        "󰁍 Back to Main")
            main_menu
            return
            ;;
    esac
    
    # Loop back to hardware menu unless going back to main
    hardware_menu
}

documents_menu() {
    # Documents submenu
    docs_menu=(
        "📄 Documents"
        "📝 Notes"
        "📚 Books"
        "󰁍 Back to Main"
    )
    
    docs_selected=$(printf '%s\n' "${docs_menu[@]}" | rofi -dmenu -i -p "Documents" -theme ~/.config/rofi/quick-actions.rasi)
    
    # Handle ESC key (empty selection)
    if [ -z "$docs_selected" ]; then
        main_menu
        return
    fi
    
    case "$docs_selected" in
        "📄 Documents")
            rofi-docs
            ;;
        "📝 Notes")
            rofi-notes
            ;;
        "📚 Books")
            rofi-docs
            ;;
        "󰁍 Back to Main")
            main_menu
            return
            ;;
    esac
    
    # Loop back to documents menu unless going back to main
    documents_menu
}

internet_menu() {
    # Internet submenu
    internet_menu=(
        "🔗 Bookmarks"
        "📥 Downloader"
        "󰁍 Back to Main"
    )
    
    internet_selected=$(printf '%s\n' "${internet_menu[@]}" | rofi -dmenu -i -p "Internet" -theme ~/.config/rofi/quick-actions.rasi)
    
    # Handle ESC key (empty selection)
    if [ -z "$internet_selected" ]; then
        main_menu
        return
    fi
    
    case "$internet_selected" in
        "🔗 Bookmarks")
            rofi-bookmarks
            ;;
        "📥 Downloader")
            rofi-aria
            ;;
        "󰁍 Back to Main")
            main_menu
            return
            ;;
    esac
    
    # Loop back to internet menu unless going back to main
    internet_menu
}

multimedia_menu() {
    # Multimedia submenu
    media_menu=(
        "🎬 Video Tools"
        "🎥 Video Player"
        "📹 Screen Record"
				"🖼️ Screenshot"
				"🖼️ Screenshot (FS)"
				"🖼️ OCR"
				"🖼️ Textpicker"
        "󰁍 Back to Main"
    )
    
    media_selected=$(printf '%s\n' "${media_menu[@]}" | rofi -dmenu -i -p "Multimedia" -theme ~/.config/rofi/quick-actions.rasi)
    
    # Handle ESC key (empty selection)
    if [ -z "$media_selected" ]; then
        main_menu
        return
    fi
    
    case "$media_selected" in
        "🎬 Video Tools")
            rofi-video-tool
            ;;
        "🎥 Video Player")
            rofi-video-list
            ;;
        "📹 Screenrecord")
            rofi-screenrecord
            ;;
				"🖼️ Screenshot")
            rofi-screenshot
            ;;
				"🖼️ Screenshot (FS)")
            rofi-screenshot-fs
            ;;
				"🖼️ OCR")
						ocr
						;;
				"🖼️ Textpicker")
						text-picker
						;;
        "󰁍 Back to Main")
            main_menu
            return
            ;;
    esac
    
    # Loop back to multimedia menu unless going back to main
    multimedia_menu
}

utilities_menu() {
    # Utilities submenu
    utils_menu=(
        "📋 Clipboard"
        "🖼️ Screenshot"
 				"🖼️ Screenshot (FS)"
        "📜 Scripts"
        "󰁍 Back to Main"
    )
    
    utils_selected=$(printf '%s\n' "${utils_menu[@]}" | rofi -dmenu -i -p "Utilities" -theme ~/.config/rofi/quick-actions.rasi)
    
    # Handle ESC key (empty selection)
    if [ -z "$utils_selected" ]; then
        main_menu
        return
    fi
    
    case "$utils_selected" in
        "📋 Clipboard")
            rofi-clipboard
            ;;
        "🖼️ Screenshot")
            rofi-screenshot
            ;;
					"🖼️ Screenshot (FS)")
 					rofi-screenshot-fs
            ;;
        "📜 Scripts")
            rofi-scripts
            ;;
        "󰁍 Back to Main")
            main_menu
            return
            ;;
    esac
    
    # Loop back to utilities menu unless going back to main
    utilities_menu
}

# Start the main menu
main_menu
