#!/usr/bin/env bash

# Interactive JPEG Manipulation Script with dmenu
# Dependencies: imagemagick, ghostscript, dmenu

# Check dependencies
for cmd in "$IM_COMMAND" gs dmenu; do
    if ! command -v "$cmd" &> /dev/null; then
        echo "Error: $cmd not found. Please install it." | dmenu -i -p "Error"
        exit 1
    fi
done

# Check ImageMagick version
if command -v magick &> /dev/null; then
    IM_COMMAND="magick"
else
    IM_COMMAND="convert"
    echo "NOTE: Using legacy 'convert' command." | dmenu -i -l 3 -p "Info"
fi

# Function to show main menu
show_main_menu() {
    echo -e "Rotate\nFlip\nBlack & White\nCrop\nConvert to PDF\nMerge to PDF\nSet Quality\nAbout\nExit" | dmenu -i -l 10 -p "JPEG Tool:"
}

# Function to select file
select_file() {
    find ~ -name "*.jpg" -o -name "*.jpeg" | dmenu -i -l 15 -p "Select JPEG:"
}

# Function to select output filename
get_output_filename() {
    local input_file="$1"
    local default_output="${input_file%.*}_modified.jpg"
    echo "$default_output" | dmenu -i -p "Output filename:" | tr -d '\n'
}

# Function to rotate menu
rotate_menu() {
    echo -e "90° Right\n180° Flip\n270° Left" | dmenu -i -l 3 -p "Rotate:"
}

# Function to flip menu
flip_menu() {
    echo -e "Horizontal\nVertical\nBoth" | dmenu -i -l 3 -p "Flip:"
}

# Function to get crop geometry
get_crop_geometry() {
    echo "Enter crop geometry (WxH+X+Y):" | dmenu -i -p "Crop Geometry:"
}

# Function to get quality
get_quality() {
    echo "90" | dmenu -i -p "Quality (1-100):"
}

# Function to process single image
process_image() {
    local input_file="$1"
    local output_file="$2"
    local rotate=""
    local flip_h=false
    local flip_v=false
    local bw=false
    local crop=""
    local quality=90
    local to_pdf=false
    
    while true; do
        action=$(show_main_menu)
        
        case "$action" in
            Rotate)
                rotation=$(rotate_menu)
                case "$rotation" in
                    "90° Right") rotate="90" ;;
                    "180° Flip") rotate="180" ;;
                    "270° Left") rotate="270" ;;
                    *) continue ;;
                esac
                ;;
            Flip)
                flip_type=$(flip_menu)
                case "$flip_type" in
                    "Horizontal") flip_h=true ;;
                    "Vertical") flip_v=true ;;
                    "Both") flip_h=true; flip_v=true ;;
                    *) continue ;;
                esac
                ;;
            "Black & White")
                bw=true
                echo "B&W conversion enabled" | dmenu -i -l 2 -p "Info"
                ;;
            Crop)
                crop=$(get_crop_geometry)
                ;;
            "Convert to PDF")
                to_pdf=true
                output_file="${input_file%.*}.pdf"
                ;;
            "Merge to PDF")
                merge_to_pdf
                return
                ;;
            "Set Quality")
                quality=$(get_quality)
                ;;
            About)
                echo "JPEG Manipulation Tool with dmenu\nUse arrow keys to navigate" | dmenu -i -l 5 -p "About"
                continue
                ;;
            Exit|"")
                if [ -n "$input_file" ]; then
                    apply_transformations "$input_file" "$output_file" "$rotate" "$flip_h" "$flip_v" "$bw" "$crop" "$quality" "$to_pdf"
                fi
                return
                ;;
            *)
                continue
                ;;
        esac
        
        # Show current settings
        current_settings="Current settings:\n"
        [ -n "$rotate" ] && current_settings+="Rotate: ${rotate}°\n"
        [ "$flip_h" = true ] && current_settings+="Flip Horizontal\n"
        [ "$flip_v" = true ] && current_settings+="Flip Vertical\n"
        [ "$bw" = true ] && current_settings+="Black & White\n"
        [ -n "$crop" ] && current_settings+="Crop: $crop\n"
        current_settings+="Quality: $quality\n"
        [ "$to_pdf" = true ] && current_settings+="Output: PDF\n"
        current_settings+="\nApply now or add more transformations?"
        
        echo -e "$current_settings" | dmenu -i -l 10 -p "Settings"
    done
}

# Function to apply transformations
apply_transformations() {
    local input_file="$1"
    local output_file="$2"
    local rotate="$3"
    local flip_h="$4"
    local flip_v="$5"
    local bw="$6"
    local crop="$7"
    local quality="$8"
    local to_pdf="$9"
    
    # Build command
    if [ "$IM_COMMAND" = "magick" ]; then
        cmd="magick \"$input_file\""
    else
        cmd="convert \"$input_file\""
    fi

    # Apply transformations in logical order
    [ -n "$crop" ] && cmd+=" -crop $crop"
    [ -n "$rotate" ] && cmd+=" -rotate $rotate"
    [ "$flip_h" = true ] && cmd+=" -flip"
    [ "$flip_v" = true ] && cmd+=" -flop"
    [ "$bw" = true ] && cmd+=" -colorspace Gray"
    cmd+=" -quality $quality"

    # Output
    if [ "$to_pdf" = true ]; then
        cmd+=" \"$output_file\""
    else
        cmd+=" \"$output_file\""
    fi

    # Execute
    if eval "$cmd"; then
        echo "Success! Output saved to $output_file" | dmenu -i -l 3 -p "Success"
    else
        echo "Error: Operation failed" | dmenu -i -l 3 -p "Error"
    fi
}

# Function to merge multiple JPEGs to PDF
merge_to_pdf() {
    echo "Select JPEGs to merge (use Tab to select multiple):" | dmenu -i -p "Info"
    local files=()
    
    while true; do
        file=$(find ~ -name "*.jpg" -o -name "*.jpeg" | dmenu -i -l 15 -p "Add JPEG (Enter when done):")
        [ -z "$file" ] && break
        files+=("$file")
        echo "Added: $(basename "$file") (Total: ${#files[@]})" | dmenu -i -l 3 -p "Added"
    done
    
    if [ ${#files[@]} -eq 0 ]; then
        echo "No files selected" | dmenu -i -p "Info"
        return
    fi
    
    local output_pdf=$(echo "merged_documents.pdf" | dmenu -i -p "Output PDF filename:")
    [ -z "$output_pdf" ] && output_pdf="merged_documents.pdf"
    
    local quality=$(get_quality)
    
    temp_pdfs=()
    for file in "${files[@]}"; do
        temp_pdf="${file%.*}.temp.pdf"
        if [ "$IM_COMMAND" = "magick" ]; then
            magick "$file" -quality "$quality" "$temp_pdf"
        else
            convert "$file" -quality "$quality" "$temp_pdf"
        fi
        temp_pdfs+=("$temp_pdf")
    done

    if gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile="$output_pdf" "${temp_pdfs[@]}"; then
        rm "${temp_pdfs[@]}"
        echo "PDF merged successfully: $output_pdf" | dmenu -i -l 3 -p "Success"
    else
        echo "PDF merge failed" | dmenu -i -l 3 -p "Error"
        rm -f "${temp_pdfs[@]}"
    fi
}

# Main execution
main() {
    while true; do
        input_file=$(select_file)
        [ -z "$input_file" ] && exit 0
        
        if [ ! -f "$input_file" ]; then
            echo "File not found: $input_file" | dmenu -i -p "Error"
            continue
        fi
        
        output_file=$(get_output_filename "$input_file")
        [ -z "$output_file" ] && output_file="${input_file%.*}_modified.jpg"
        
        process_image "$input_file" "$output_file"
    done
}

# Run main function
main