#!/bin/bash

# Color codes for better output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Set target directories (relative to current folder)
MOVIES_DIR="Movies"
SERIES_DIR="Series"

# Video file extensions (add more if needed)
VIDEO_EXTS=("mp4" "mkv" "avi" "mov" "wmv" "flv" "webm" "m4v" "mpg" "mpeg" "3gp")

# Function to check if file is a video
is_video() {
    local file="$1"
    local ext="${file##*.}"
    ext="${ext,,}"  # Convert to lowercase
    
    for video_ext in "${VIDEO_EXTS[@]}"; do
        if [[ "$ext" == "$video_ext" ]]; then
            return 0
        fi
    done
    return 1
}

# Function to clean filename (remove common patterns)
clean_filename() {
    local filename="$1"
    # Remove extension
    filename="${filename%.*}"
    # Remove common patterns like [WEBRip], [1080p], etc.
    filename=$(echo "$filename" | sed -E 's/[\[\(][^\]\)]*[\]\)]//g')
    # Remove year patterns (YYYY) - but we'll keep them for matching
    # Remove quality indicators
    filename=$(echo "$filename" | sed -E 's/[0-9]+[0-9]*p//g')
    # Remove common words
    filename=$(echo "$filename" | sed -E 's/(WEBRip|BRRip|BluRay|HDRip|DVDRip|x264|x265|HEVC|AC3)//gi')
    # Clean up extra spaces and dots
    filename=$(echo "$filename" | sed -E 's/[._]/ /g' | sed -E 's/ +/ /g' | sed -E 's/^ +| +$//g')
    echo "$filename"
}

# Function to extract base series name (without season/episode info)
extract_series_name() {
    local filename="$1"
    # Remove extension
    filename="${filename%.*}"
    # Remove season/episode patterns
    local name=$(echo "$filename" | sed -E 's/[Ss][0-9]+[Ee][0-9]+//' | \
                 sed -E 's/[0-9]+[Xx][0-9]+//' | \
                 sed -E 's/[Ss]eason[[:space:]]*[0-9]+//' | \
                 sed -E 's/[Ee]pisode[[:space:]]*[0-9]+//' | \
                 sed -E 's/[\._]/ /g' | \
                 sed -E 's/ +/ /g' | \
                 sed -E 's/^ +| +$//g')
    echo "$name"
}

# Function to normalize a name for comparison (remove special chars, extra spaces)
normalize_name() {
    local name="$1"
    # Convert to lowercase
    name=$(echo "$name" | tr '[:upper:]' '[:lower:]')
    # Remove parentheses and their contents (like (2021))
    name=$(echo "$name" | sed -E 's/\([^)]*\)//g')
    # Remove brackets and their contents
    name=$(echo "$name" | sed -E 's/\[[^]]*\]//g')
    # Remove punctuation and special characters
    name=$(echo "$name" | sed -E 's/[^a-z0-9 ]/ /g')
    # Remove extra spaces
    name=$(echo "$name" | sed -E 's/ +/ /g' | sed -E 's/^ +| +$//g')
    echo "$name"
}

# Function to check if it's a TV series episode
is_series() {
    local filename="$1"
    # Check for common series patterns: S01E02, S1E2, 1x01, etc.
    if [[ "$filename" =~ [Ss][0-9]+[Ee][0-9]+ ]] || \
       [[ "$filename" =~ [0-9]+[Xx][0-9]+ ]] || \
       [[ "$filename" =~ [Ss]eason[[:space:]]*[0-9]+ ]] || \
       [[ "$filename" =~ [Ee]pisode[[:space:]]*[0-9]+ ]]; then
        return 0
    fi
    return 1
}

# Function to find matching series folder with smart matching
find_series_folder() {
    local series_name="$1"
    
    # Normalize the series name for comparison
    local normalized_search=$(normalize_name "$series_name")
    
    # Check if Series directory exists
    if [[ ! -d "$SERIES_DIR" ]]; then
        return 1
    fi
    
    # First, try exact match (case insensitive)
    for folder in "$SERIES_DIR"/*/; do
        if [[ -d "$folder" ]]; then
            folder_name=$(basename "$folder")
            # Remove year and extra info for comparison
            local normalized_folder=$(normalize_name "$folder_name")
            
            # Exact match after normalization
            if [[ "$normalized_folder" == "$normalized_search" ]]; then
                echo "$folder"
                return 0
            fi
        fi
    done
    
    # If no exact match, try contains match
    local best_match=""
    local highest_score=0
    
    for folder in "$SERIES_DIR"/*/; do
        if [[ -d "$folder" ]]; then
            folder_name=$(basename "$folder")
            local normalized_folder=$(normalize_name "$folder_name")
            
            # Check if search term is contained in folder name or vice versa
            if [[ "$normalized_folder" == *"$normalized_search"* ]] || \
               [[ "$normalized_search" == *"$normalized_folder"* ]]; then
                # Calculate a simple score based on length match
                local score=${#normalized_folder}
                if [[ $score -gt $highest_score ]]; then
                    highest_score=$score
                    best_match="$folder"
                fi
            fi
        fi
    done
    
    if [[ -n "$best_match" ]]; then
        echo "$best_match"
        return 0
    fi
    
    return 1
}

# Main script starts here
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}    VIDEO FILE ORGANIZER SCRIPT       ${NC}"
echo -e "${BLUE}========================================${NC}"
echo

# Create directories if they don't exist
mkdir -p "$MOVIES_DIR" "$SERIES_DIR"

# Arrays to store files for processing
declare -a movie_files
declare -a series_files
declare -a series_matches
declare -a series_names

# Scan for video files
echo -e "${YELLOW}Scanning for video files...${NC}"
echo

for file in *; do
    # Skip if not a regular file
    [[ -f "$file" ]] || continue
    
    # Skip if file is already in Movies or Series folder
    [[ "$file" == "$MOVIES_DIR" ]] || [[ "$file" == "$SERIES_DIR" ]] && continue
    
    # Check if it's a video file
    if is_video "$file"; then
        clean_name=$(clean_filename "$file")
        
        if is_series "$file"; then
            series_files+=("$file")
            series_name=$(extract_series_name "$file")
            series_names+=("$series_name")
            echo -e "${GREEN}[SERIES]${NC} $file"
        else
            movie_files+=("$file")
            echo -e "${BLUE}[MOVIE]${NC} $file"
        fi
    fi
done

echo
echo -e "${YELLOW}Found ${#movie_files[@]} movies and ${#series_files[@]} series episodes${NC}"
echo

# If no files found, exit
if [[ ${#movie_files[@]} -eq 0 ]] && [[ ${#series_files[@]} -eq 0 ]]; then
    echo -e "${RED}No video files found in current directory.${NC}"
    exit 0
fi

# Show what will be moved
echo -e "${YELLOW}The following operations will be performed:${NC}"
echo

# Show movie moves
for file in "${movie_files[@]}"; do
    echo -e "  ${BLUE}MOVIE:${NC} $file -> $MOVIES_DIR/"
done

# Show series moves and find matching folders
declare -a series_targets
declare -a series_need_new_folder

for i in "${!series_files[@]}"; do
    file="${series_files[$i]}"
    series_name="${series_names[$i]}"
    
    target_folder=$(find_series_folder "$series_name")
    
    if [[ -n "$target_folder" ]]; then
        echo -e "  ${GREEN}SERIES:${NC} $file -> $target_folder"
        series_targets+=("$target_folder")
        series_need_new_folder+=("false")
    else
        # Check if there's a folder with a similar name (case insensitive)
        found_similar=""
        for folder in "$SERIES_DIR"/*/; do
            if [[ -d "$folder" ]]; then
                folder_name=$(basename "$folder")
                # Check if folder name contains series name (case insensitive)
                if [[ "${folder_name,,}" =~ "${series_name,,}" ]] || \
                   [[ "${series_name,,}" =~ "${folder_name,,}" ]]; then
                    found_similar="$folder"
                    break
                fi
            fi
        done
        
        if [[ -n "$found_similar" ]]; then
            echo -e "  ${GREEN}SERIES:${NC} $file -> $found_similar (matched by similarity)"
            series_targets+=("$found_similar")
            series_need_new_folder+=("false")
        else
            # Clean up series name for new folder
            new_folder_name=$(echo "$series_name" | sed -E 's/[._]/ /g' | sed -E 's/ +/ /g' | sed -E 's/^ +| +$//g')
            echo -e "  ${YELLOW}NEW SERIES:${NC} $file -> $SERIES_DIR/$new_folder_name/"
            series_targets+=("")
            series_need_new_folder+=("true")
        fi
    fi
done

echo
echo -e "${YELLOW}Total: ${#movie_files[@]} movies, ${#series_files[@]} series episodes${NC}"
echo

# Ask for confirmation
echo -e "${RED}Do you want to proceed with moving these files?${NC}"
read -p "Type 'yes' to confirm or 'no' to cancel: " confirmation

if [[ "$confirmation" != "yes" ]]; then
    echo -e "${RED}Operation cancelled.${NC}"
    exit 0
fi

# Perform the moves
echo
echo -e "${BLUE}Moving files...${NC}"

# Move movies
for file in "${movie_files[@]}"; do
    if mv "$file" "$MOVIES_DIR/"; then
        echo -e "${GREEN}✓${NC} Moved $file to $MOVIES_DIR/"
    else
        echo -e "${RED}✗${NC} Failed to move $file"
    fi
done

# Move series
for i in "${!series_files[@]}"; do
    file="${series_files[$i]}"
    target_folder="${series_targets[$i]}"
    need_new="${series_need_new_folder[$i]}"
    
    if [[ "$need_new" == "true" ]]; then
        series_name="${series_names[$i]}"
        # Clean up series name for new folder
        new_folder_name=$(echo "$series_name" | sed -E 's/[._]/ /g' | sed -E 's/ +/ /g' | sed -E 's/^ +| +$//g')
        target_folder="$SERIES_DIR/$new_folder_name"
        mkdir -p "$target_folder"
    fi
    
    if mv "$file" "$target_folder/"; then
        echo -e "${GREEN}✓${NC} Moved $file to $target_folder/"
    else
        echo -e "${RED}✗${NC} Failed to move $file"
    fi
done

echo
echo -e "${GREEN}Done!${NC}"

# Show summary
echo
echo -e "${BLUE}Summary:${NC}"
echo -e "  Movies moved: ${#movie_files[@]}"
echo -e "  Series episodes moved: ${#series_files[@]}"

# Check if there are any remaining files
remaining_files=$(find . -maxdepth 1 -type f | wc -l)
if [[ $remaining_files -gt 0 ]]; then
    echo -e "${YELLOW}Note: There are still $remaining_files files in the current directory${NC}"
    echo -e "${YELLOW}These might be non-video files or files that couldn't be processed.${NC}"
fi