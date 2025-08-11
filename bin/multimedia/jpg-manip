#!/usr/bin/env bash

# Ultimate JPEG Manipulation Script (Bash/Zsh)
# Features: Rotation, Flipping, B&W, Cropping, PDF conversion
# Dependencies: imagemagick, ghostscript

# Check ImageMagick version
if command -v magick &> /dev/null; then
    IM_COMMAND="magick"
else
    IM_COMMAND="convert"
    echo "NOTE: Using legacy 'convert' command. For ImageMagick v7, use 'magick' instead."
fi

show_help() {
    echo "Usage: jpg-manip.sh [options] input.jpg [output]"
    echo
    echo "Transformations:"
    echo "  -r DEGREES  Rotate image (90, 180, or 270)"
    echo "  -f          Flip horizontally (mirror)"
    echo "  -v          Flip vertically"
    echo "  -b          Convert to black and white"
    echo "  -c GEOMETRY Crop image (WxH+X+Y, e.g., 300x200+10+5)"
    echo
    echo "PDF Options:"
    echo "  -p          Convert to PDF (single image)"
    echo "  -m          Merge multiple JPEGs into one PDF"
    echo
    echo "Other:"
    echo "  -q QUALITY  Set JPEG quality (1-100, default: 90)"
    echo "  -h          Show this help"
    echo
    echo "Examples:"
    echo "  jpg-manip.sh -r 180 input.jpg          # Fix upside-down scan"
    echo "  jpg-manip.sh -f selfie.jpg            # Mirror flip"
    echo "  jpg-manip.sh -b -p document.jpg       # B&W then convert to PDF"
    echo "  jpg-manip.sh -m *.jpg combined.pdf    # Merge multiple JPEGs"
}

# Default values
rotate_degrees=0
flip_h=false
flip_v=false
bw=false
crop_geometry=""
to_pdf=false
merge_pdf=false
quality=90
output_file=""

# Parse options
while getopts "r:fvbc:pmq:h" opt; do
    case $opt in
        r) rotate_degrees="$OPTARG" ;;
        f) flip_h=true ;;
        v) flip_v=true ;;
        b) bw=true ;;
        c) crop_geometry="$OPTARG" ;;
        p) to_pdf=true ;;
        m) merge_pdf=true ;;
        q) quality="$OPTARG" ;;
        h) show_help; exit 0 ;;
        *) show_help; exit 1 ;;
    esac
done
shift $((OPTIND-1))

# Check arguments
if [ $# -lt 1 ]; then
    show_help
    exit 1
fi

# Validate rotation
if [[ "$rotate_degrees" -ne 0 ]] && [[ ! "$rotate_degrees" =~ ^(90|180|270)$ ]]; then
    echo "Error: Rotation must be 90, 180, or 270 degrees"
    exit 1
fi

# Handle PDF merging
if [ "$merge_pdf" = true ]; then
    input_files=("$@")
    output_pdf="${input_files[-1]}"
    unset 'input_files[-1]'
    
    temp_pdfs=()
    for file in "${input_files[@]}"; do
        if [ ! -f "$file" ]; then
            echo "Error: File $file not found"
            exit 1
        fi
        temp_pdf="${file%.*}.temp.pdf"
        if [ "$IM_COMMAND" = "magick" ]; then
            magick "$file" -quality "$quality" "$temp_pdf"
        else
            convert "$file" -quality "$quality" "$temp_pdf"
        fi
        temp_pdfs+=("$temp_pdf")
    done
    
    gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile="$output_pdf" "${temp_pdfs[@]}"
    rm "${temp_pdfs[@]}"
    exit 0
fi

# Single file operations
input_file="$1"
if [ $# -ge 2 ]; then
    output_file="$2"
else
    if [ "$to_pdf" = true ]; then
        output_file="${input_file%.*}.pdf"
    else
        output_file="${input_file%.*}_modified.jpg"
    fi
fi

if [ ! -f "$input_file" ]; then
    echo "Error: Input file $input_file not found"
    exit 1
fi

# Build command
if [ "$IM_COMMAND" = "magick" ]; then
    cmd="magick \"$input_file\""
else
    cmd="convert \"$input_file\""
fi

# Apply transformations in logical order
[ -n "$crop_geometry" ] && cmd+=" -crop $crop_geometry"
[ "$rotate_degrees" -ne 0 ] && cmd+=" -rotate $rotate_degrees"
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
eval "$cmd"

echo "Operation completed. Output saved to $output_file"
