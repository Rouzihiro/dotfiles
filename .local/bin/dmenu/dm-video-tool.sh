#!/usr/bin/env bash
# video-tool-dmenu.sh — video toolbox with dmenu interface

# Output directories
VIDEO_OUT_DIR="$HOME/Videos"
MERGE_OUT_DIR="$VIDEO_OUT_DIR/merged"
SPLIT_OUT_DIR="$VIDEO_OUT_DIR/split"
GIF_OUT_DIR="$VIDEO_OUT_DIR/gifs"
THUMB_OUT_DIR="$VIDEO_OUT_DIR/thumbnails"
CONVERT_OUT_DIR="$VIDEO_OUT_DIR/converted"

mkdir -p "$MERGE_OUT_DIR" "$SPLIT_OUT_DIR" "$GIF_OUT_DIR" "$THUMB_OUT_DIR" "$CONVERT_OUT_DIR"

# Dmenu configuration
DMENU_CMD="dmenu"
DMENU_OPTS="-i -l 15"
DMENU_SINGLE_OPTS="-i -l 10"

# --- Select single file with dmenu ---
select_single_with_dmenu() {
    local prompt="$1"
    printf '%s\n' "${video_files[@]}" | ${DMENU_CMD} ${DMENU_SINGLE_OPTS} -p "$prompt"
}

# --- Select multiple files with dmenu (iterative) ---
select_multiple_with_dmenu() {
    local prompt="$1"
    local selected=()
    local remaining=("${video_files[@]}")
    
    while true; do
        # Show remaining files with option to finish
        choice=$(printf "DONE SELECTING\n%s" "${remaining[@]}" | ${DMENU_CMD} ${DMENU_OPTS} -p "$prompt")
        
        if [ -z "$choice" ]; then
            break
        fi
        
        if [ "$choice" = "DONE SELECTING" ]; then
            break
        fi
        
        # Add to selected and remove from remaining
        selected+=("$choice")
        temp=()
        for file in "${remaining[@]}"; do
            if [ "$file" != "$choice" ]; then
                temp+=("$file")
            fi
        done
        remaining=("${temp[@]}")
        
        echo "Selected: ${#selected[@]} files" | ${DMENU_CMD} -i -l 2 -p "Status"
    done
    
    printf '%s\n' "${selected[@]}"
}

# --- Get user input with dmenu ---
get_input() {
    local prompt="$1"
    local default="$2"
    echo "$default" | ${DMENU_CMD} -i -p "$prompt"
}

# --- Merge videos safely ---
merge_videos() {
    local files=("$@")
    if [ ${#files[@]} -eq 0 ]; then
        echo "No files selected" | ${DMENU_CMD} -i -p "Error"
        return
    fi
    
    local tmp
    tmp=$(mktemp)
    for f in "${files[@]}"; do
        local esc="${f//\'/\'\\\'\'}"
        echo "file '$esc'" >> "$tmp"
    done
    local out="$MERGE_OUT_DIR/merged_$(date +%Y%m%d_%H%M%S).mkv"
    if ffmpeg -f concat -safe 0 -i "$tmp" -c copy "$out" 2>/dev/null; then
        echo "✅ Merged file: $out" | ${DMENU_CMD} -i -l 3 -p "Success"
    else
        echo "❌ Merge failed" | ${DMENU_CMD} -i -l 3 -p "Error"
    fi
    rm "$tmp"
}

# --- Merge & Compress videos ---
merge_and_compress() {
    local files=("$@")
    if [ ${#files[@]} -eq 0 ]; then
        echo "No files selected" | ${DMENU_CMD} -i -p "Error"
        return
    fi
    
    local tmp
    tmp=$(mktemp)
    for f in "${files[@]}"; do
        local esc="${f//\'/\'\\\'\'}"
        echo "file '$esc'" >> "$tmp"
    done
    local out="$MERGE_OUT_DIR/merged_compressed_$(date +%Y%m%d_%H%M%S).mp4"
    if ffmpeg -f concat -safe 0 -i "$tmp" -c:v libx265 -preset fast -crf 28 -c:a aac -b:a 128k "$out" 2>/dev/null; then
        echo "✅ Merged & Compressed file: $out" | ${DMENU_CMD} -i -l 3 -p "Success"
    else
        echo "❌ Merge & compress failed" | ${DMENU_CMD} -i -l 3 -p "Error"
    fi
    rm "$tmp"
}

# --- Split video ---
split_video() {
    local file="$1"
    if [ -z "$file" ]; then
        echo "No file selected" | ${DMENU_CMD} -i -p "Error"
        return
    fi
    
    local start=$(get_input "Start time (HH:MM:SS)" "00:00:00")
    local end=$(get_input "End time (HH:MM:SS)" "00:01:00")
    local base=$(basename "$file")
    local out="$SPLIT_OUT_DIR/split_${base%.*}_$(date +%H%M%S).${base##*.}"
    
    if ffmpeg -i "$file" -ss "$start" -to "$end" -c copy "$out" 2>/dev/null; then
        echo "✅ Split saved: $out" | ${DMENU_CMD} -i -l 3 -p "Success"
    else
        echo "❌ Split failed" | ${DMENU_CMD} -i -l 3 -p "Error"
    fi
}

# --- Convert video ---
convert_video() {
    local file="$1"
    if [ -z "$file" ]; then
        echo "No file selected" | ${DMENU_CMD} -i -p "Error"
        return
    fi
    
    local vcodec=$(echo -e "libx264\nlibx265\ncopy" | ${DMENU_CMD} -i -l 3 -p "Video codec")
    local acodec=$(echo -e "aac\nmp3\ncopy" | ${DMENU_CMD} -i -l 3 -p "Audio codec")
    local preset=$(echo -e "fast\nmedium\nslow" | ${DMENU_CMD} -i -l 3 -p "Preset")
    
    vcodec=${vcodec:-libx264}
    acodec=${acodec:-aac}
    preset=${preset:-fast}
    
    local base=$(basename "$file")
    local out="$CONVERT_OUT_DIR/${base%.*}.mkv"
    
    if ffmpeg -i "$file" -c:v "$vcodec" -preset "$preset" -c:a "$acodec" "$out" 2>/dev/null; then
        echo "✅ Converted: $out" | ${DMENU_CMD} -i -l 3 -p "Success"
    else
        echo "❌ Conversion failed" | ${DMENU_CMD} -i -l 3 -p "Error"
    fi
}

# --- Create GIF ---
make_gif() {
    local file="$1"
    if [ -z "$file" ]; then
        echo "No file selected" | ${DMENU_CMD} -i -p "Error"
        return
    fi
    
    local start=$(get_input "Start time (HH:MM:SS)" "00:00:00")
    local duration=$(get_input "Duration (seconds)" "5")
    local base=$(basename "$file")
    local out="$GIF_OUT_DIR/${base%.*}_$(date +%H%M%S).gif"
    
    if ffmpeg -ss "$start" -t "$duration" -i "$file" -vf "fps=15,scale=480:-1:flags=lanczos" "$out" 2>/dev/null; then
        echo "✅ GIF saved: $out" | ${DMENU_CMD} -i -l 3 -p "Success"
    else
        echo "❌ GIF creation failed" | ${DMENU_CMD} -i -l 3 -p "Error"
    fi
}

# --- Create Thumbnail ---
make_thumbnail() {
    local file="$1"
    if [ -z "$file" ]; then
        echo "No file selected" | ${DMENU_CMD} -i -p "Error"
        return
    fi
    
    local timestamp=$(get_input "Time for thumbnail (HH:MM:SS)" "00:00:05")
    local base=$(basename "$file")
    local out="$THUMB_OUT_DIR/${base%.*}_thumb.jpg"
    
    if ffmpeg -ss "$timestamp" -i "$file" -vframes 1 "$out" 2>/dev/null; then
        echo "✅ Thumbnail saved: $out" | ${DMENU_CMD} -i -l 3 -p "Success"
    else
        echo "❌ Thumbnail creation failed" | ${DMENU_CMD} -i -l 3 -p "Error"
    fi
}

# --- Show metadata ---
show_metadata() {
    local file="$1"
    if [ -z "$file" ]; then
        echo "No file selected" | ${DMENU_CMD} -i -p "Error"
        return
    fi
    
    # Show basic metadata in dmenu
    ffprobe -hide_banner "$file" 2>&1 | head -n 20 | ${DMENU_CMD} -i -l 20 -p "Metadata:"
}

# --- Collect video files ---
video_files=()
while IFS= read -r -d '' file; do
    video_files+=("$file")
done < <(find ~/Downloads ~/Videos -type f \( -iname "*.mp4" -o -iname "*.mkv" -o -iname "*.mov" -o -iname "*.avi" -o -iname "*.webm" \) -print0 2>/dev/null)

if [ ${#video_files[@]} -eq 0 ]; then
    echo "❌ No video files found in ~/Downloads or ~/Videos." | ${DMENU_CMD} -i -p "Error"
    exit 1
fi

# --- Main menu with dmenu ---
while true; do
    action=$(echo -e "Merge videos\nMerge & Compress videos\nSplit video\nConvert video\nMake GIF\nMake thumbnail\nShow metadata\nExit" | ${DMENU_CMD} ${DMENU_OPTS} -p "")
    
    case "$action" in
        "Merge videos")
            files=$(select_multiple_with_dmenu "Select videos to merge")
            if [ -n "$files" ]; then
                # Convert newline-separated list to array
                IFS=$'\n' read -d '' -r -a file_array <<< "$files"
                merge_videos "${file_array[@]}"
            fi
            ;;
        "Merge & Compress videos")
            files=$(select_multiple_with_dmenu "Select videos to merge & compress")
            if [ -n "$files" ]; then
                IFS=$'\n' read -d '' -r -a file_array <<< "$files"
                merge_and_compress "${file_array[@]}"
            fi
            ;;
        "Split video")
            file=$(select_single_with_dmenu "Select video to split")
            split_video "$file"
            ;;
        "Convert video")
            file=$(select_single_with_dmenu "Select video to convert")
            convert_video "$file"
            ;;
        "Make GIF")
            file=$(select_single_with_dmenu "Select video for GIF")
            make_gif "$file"
            ;;
        "Make thumbnail")
            file=$(select_single_with_dmenu "Select video for thumbnail")
            make_thumbnail "$file"
            ;;
        "Show metadata")
            file=$(select_single_with_dmenu "Select video for metadata")
            show_metadata "$file"
            ;;
        "Exit"|"")
            break
            ;;
    esac
done
