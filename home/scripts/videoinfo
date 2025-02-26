#!/bin/sh

# Function to handle file selection (multiple files)
select_files() {
    local selected_files
    selected_files=$(find . -type f \( -iname \*.avi -o -iname \*.mp4 -o -iname \*.mkv -o -iname \*.flv -o -iname \*.webm \) | wofi --dmenu --multiple --prompt "Select video files")
    echo "$selected_files"
}

# Get files to inspect
files_to_inspect=$(select_files)

# Check if any files were selected
if [ -z "$files_to_inspect" ]; then
    notify-send "Codec Information" "No files selected. Exiting."
    exit 1
fi

# Loop through each selected file and display codec information
for file_to_inspect in $files_to_inspect; do
    echo "Encoding Parameters for: $file_to_inspect"
    
    # Video stream information
    echo "Video Stream:"
    ffprobe -v error -select_streams v:0 -show_entries stream=codec_name,codec_type,profile,level,gop_size,pix_fmt "$file_to_inspect"
    
    # Audio stream information
    echo "Audio Stream:"
    ffprobe -v error -select_streams a:0 -show_entries stream=codec_name,codec_type,sample_rate,channels,bit_rate "$file_to_inspect"
    
    echo "-------------------------"
done

