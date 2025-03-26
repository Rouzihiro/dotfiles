{pkgs}:
pkgs.writeShellScriptBin "compresso" ''
#!/bin/sh

# Colors with proper Nix escaping
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'  # No Color

show_help() {
    echo "Usage:"
    echo "  compresso [input1 input2...]  # Interactive mode"
    echo "  compresso -h                  # Show help"
    echo "Smart compression with format suggestions and prompts"
}

recommend_format() {
    local input="$1"
    local file_type=$(file -b --mime-type "$input" 2>/dev/null)
    local size=$(du -sh "$input" 2>/dev/null | cut -f1)

    if [ -d "$input" ]; then
        echo "tar.gz tar.xz tar.bz2 zip 7z"
        return
    fi

    case "$file_type" in
        text/*|application/json) echo "gz xz zip" ;;
        image/*|video/*|audio/*) echo "zip 7z" ;;
        application/gzip|application/x-bzip2) echo "keep as-is" ;;
        *) echo "tar.gz zip 7z xz" ;;
    esac
}

prompt_format() {
    local input="$1"
    local default_ext=""
    local recommendations=$(recommend_format "$input")
    
    if [ -d "$input" ]; then
        default_ext="tar.gz"
        echo -e "\n''${BLUE}Directory detected:''${NC} $input"
    elif [ $(echo "$input" | wc -l) -gt 1 ]; then
        default_ext="zip"
        echo -e "\n''${BLUE}Multiple files detected:''${NC}"
        echo "$input" | xargs -n1 echo " -"
    else
        default_ext="gz"
        echo -e "\n''${BLUE}File detected:''${NC} $input"
        echo -e "Type: $(file -b --mime-type "$input")"
        echo -e "Size: $(du -sh "$input" | cut -f1)"
    fi

    echo -e "\n''${GREEN}Recommended formats:''${NC} $recommendations"
    echo -e "''${YELLOW}Choose compression format:''${NC}"
    select format in $recommendations "custom" "abort"; do
        case $format in
            abort) exit 1 ;;
            custom)
                read -p "Enter format (ext): " format
                break ;;
            *) 
                [[ -n "$format" ]] && break
                echo "Invalid choice!" >&2 ;;
        esac
    done

    format=''${format:-$default_ext}
    echo "$format"
}

handle_compression() {
    local format="$1"
    shift
    local inputs=("$@")
    
    local first_input=$(basename "''${inputs[0]}")
    local default_output="archive"
    [ ''${#inputs[@]} -eq 1 ] && default_output="$first_input"
    
    read -p "Output name (default: $default_output): " output_name
    output_name=''${output_name:-$default_output}
    
    [[ "$output_name" != *."$format" ]] && output_name="$output_name.$format"

    case "$format" in
        tar.gz|tgz) tar -czvf "$output_name" "''${inputs[@]}" ;;
        tar.xz|txz) tar -cJvf "$output_name" "''${inputs[@]}" ;;
        tar.bz2|tbz2) tar -cjvf "$output_name" "''${inputs[@]}" ;;
        zip) zip -r "$output_name" "''${inputs[@]}" ;;
        gz) gzip -kvc "''${inputs[0]}" > "$output_name" ;;
        xz) xz -zkvc "''${inputs[0]}" > "$output_name" ;;
        7z) 7z a "$output_name" "''${inputs[@]}" ;;
        *) echo "Unsupported format: $format" >&2; exit 1 ;;
    esac

    echo -e "\n''${GREEN}Successfully created:''${NC} $output_name"
    echo -e "Final size: $(du -sh "$output_name" | cut -f1)"
}

# Main script
[ $# -eq 0 ] || [ "$1" = "-h" ] && { show_help; exit 0; }

inputs=()
for arg in "$@"; do
    [[ "$arg" == *"*"* ]] && inputs+=($arg) || inputs+=("$arg")
done

for input in "''${inputs[@]}"; do
    [ ! -e "$input" ] && { echo -e "''${RED}Error: Input '$input' not found''${NC}" >&2; exit 1; }
done

format=$(prompt_format "''${inputs[@]}")
handle_compression "$format" "''${inputs[@]}"
''
