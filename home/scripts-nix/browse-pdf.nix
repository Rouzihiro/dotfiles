{pkgs}:
pkgs.writeShellScriptBin "browse-pdf" ''
#!/bin/sh

# Directories to search for PDF files
DIRS="$HOME/Downloads $HOME/Pictures $HOME/Documents"

# Find all PDF files in the specified directories
PDF_FILES=$(find $DIRS -type f -iname '*.pdf' 2>/dev/null)

# Check if any PDF files were found
if [ -z "$PDF_FILES" ]; then
    notify-send "No PDF files found in the specified directories."
    exit 1
fi

# Create a mapping of display name to full path
FILE_LIST=$(echo "$PDF_FILES" | awk -F'/' '{print $(NF-1) "/" $NF "|" $0}')

# Display the files in wofi with custom size
SELECTED=$(echo "$FILE_LIST" | awk -F'|' '{print $1}' | wofi --show dmenu \
    --prompt "Select a PDF to open with Zathura" \
    --width 800 \
    --height 600)

# Check if the user selected a file
if [ -z "$SELECTED" ]; then
    exit 0
fi

# Find the corresponding full path
SELECTED_FILE=$(echo "$FILE_LIST" | grep -F "$SELECTED|" | awk -F'|' '{print $2}')

# Check if the selected file exists
if [ -z "$SELECTED_FILE" ]; then
    notify-send "Selected file not found."
    exit 1
fi

# Open the selected file with Zathura
zathura "$SELECTED_FILE"
''
