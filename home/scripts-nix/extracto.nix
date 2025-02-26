{ pkgs }:

pkgs.writeShellScriptBin "extracto" ''
  #!/bin/sh

  # Universal extract script with better error handling and automatic overwrite
  show_help() {
    echo "Usage: extracto <archive> [<archive2> ...]"
    echo "Supported formats: .tar.gz, .tgz, .tar.bz2, .tbz2, .tar.xz, .txz, .zip, .gz, .bz2, .xz, .rar, .7z, .ecm"
  }

  if [ $# -eq 0 ]; then
    show_help
    exit 1
  fi

  for file in "$@"; do
    echo "Extracting: $file"

    WORKING_DIR=$(dirname "$file")
    cd "$WORKING_DIR" || {
      echo "Error: Could not change directory to $WORKING_DIR" >&2
      exit 1
    }

    case "$file" in
      *.tar.gz | *.tgz)
        tar -xzvf "$file"
        ;;
      *.tar.bz2 | *.tbz2)
        tar -xjvf "$file"
        ;;
      *.tar.xz | *.txz)
        tar -xJvf "$file"
        ;;
      *.zip)
        unzip -o "$file" # -o for overwrite
        ;;
      *.gz)
        gunzip -kv "$file"
        ;;
      *.bz2)
        bunzip2 -kv "$file"
        ;;
      *.xz)
        unxz -kv "$file"
        ;;
      *.rar)
        unrar x -o+ "$file" # -o+ for overwrite
        ;;
      *.7z)
        7z -y x "$file" # -y for yes to all (including overwrite)
        ;;
      *.ecm)
        ecm2bin "$file" "$(basename "$file" .ecm).bin"
        ;;
      *)
        echo "Unsupported file type: $file" >&2
        exit 2
        ;;
    esac

    cd - || {
      echo "Error: Could not return to original directory" >&2
      exit 1
    }
    echo "Successfully extracted: $file"
  done
''
