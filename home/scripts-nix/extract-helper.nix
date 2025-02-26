{ pkgs }:

pkgs.writeShellScriptBin "extract-helper" ''
  # Set the extraction directory to ~/Downloads/extracted
  E_DIR="$HOME/Downloads/extracted"
  mkdir -p "$E_DIR"

  # Use `find` to get a list of matching files only from ~/Downloads and its subfolders, then pass it to Wofi
  S_FILE=$(find ~/Downloads -type f \( -iname "*.tar.gz" -o -iname "*.tgz" -o -iname "*.tar.bz2" -o -iname "*.tbz2" -o -iname "*.tar.xz" -o -iname "*.txz" -o -iname "*.zip" -o -iname "*.gz" -o -iname "*.bz2" -o -iname "*.xz" -o -iname "*.rar" -o -iname "*.7z" -o -iname "*.ecm" \) | wofi --dmenu --title "Select an archive to extract")

  # Check if a file was selected
  if [[ -n "$S_FILE" ]]; then
    # Extract the selected file into the extraction directory
    case "$S_FILE" in
      *.tar.gz|*.tgz) 
        tar -xzvf "$S_FILE" -C "$E_DIR" 
        ;;
      *.tar.bz2|*.tbz2) 
        tar -xjvf "$S_FILE" -C "$E_DIR"
        ;;
      *.tar.xz|*.txz) 
        tar -xJvf "$S_FILE" -C "$E_DIR"
        ;;
      *.zip) 
        unzip "$S_FILE" -d "$E_DIR"
        ;;
      *.gz) 
        gunzip -c "$S_FILE" > "$E_DIR/$(basename "$S_FILE" .gz)"
        ;;
      *.bz2) 
        bunzip2 -c "$S_FILE" > "$E_DIR/$(basename "$S_FILE" .bz2)"
        ;;
      *.xz) 
        unxz -c "$S_FILE" > "$E_DIR/$(basename "$S_FILE" .xz)"
        ;;
      *.rar) 
        unrar x "$S_FILE" "$E_DIR" ;; # Requires `unrar`
      *.7z)  
        7z x "$S_FILE" -o"$E_DIR" ;;     # Requires `p7zip`
      *.ecm) 
        ecm2bin "$S_FILE" && mv "$(dirname "$S_FILE")/$(basename "$S_FILE" .ecm)" "$E_DIR" ;; # Requires `ecmtools`
      *)
        notify-send "Error" "Unsupported file type: $S_FILE" -i "dialog-error" -u critical
        exit 1
        ;;
    esac

    # Check if the extraction was successful
    if [[ $? -eq 0 ]]; then
      notify-send "Success" "Extraction completed successfully to $E_DIR!" -i "dialog-information" -u normal
    else
      notify-send "Error" "An error occurred during extraction." -i "dialog-error" -u critical
    fi
  else
    # Notify if no file was selected
    notify-send "Error" "No file selected." -i "dialog-error" -u critical
  fi
''
