{pkgs, ...}: {
  xdg.configFile."lf/icons".source = ./icons;
  programs.lf = {
    enable = true;
    commands = {
      editor-open = ''$$EDITOR $f'';
      mkdir = ''
        ''${{
          printf "Directory Name: "
          read DIR
          mkdir $DIR
        }}
      '';
      touch = ''
        ''${{
          printf "File Name: "
          read FILE
          touch $FILE
        }}
      '';
      open-terminal = ''
        ''${{
          foot sh -c "cd \"$PWD\" && $SHELL"
        }}
      '';

      copy-path = ''
        ''${{
          if [ -n "$f" ]; then
            echo -n "$PWD/$f" | ${pkgs.wl-clipboard}/bin/wl-copy
          else
            echo -n "$PWD" | ${pkgs.wl-clipboard}/bin/wl-copy
          fi
          lf -remote "send $id echo 'Absolute path copied to clipboard: $PWD/$f'"
        }}
      '';

      bulk-rename = ''
        ''${{
          # Generate a list of files with line numbers
          tmpfile=$(mktemp)
          ls --group-directories-first | ${pkgs.gawk}/bin/awk '{print NR, $0}' > "$tmpfile"

          # Open the file in Neovim
          $EDITOR "$tmpfile"

          # Debug: Print the contents of the temporary file
          echo "Contents of temporary file after editing:"
          cat "$tmpfile"

          # Read original filenames into an array
          original_files=()
          while IFS= read -r -d $'\n' file; do
            original_files+=("$file")
          done < <(ls --group-directories-first)

          # Debug: Print the original files array
          echo "Original files:"
          printf '%s\n' "''${original_files[@]}"

          # Generate rename commands
          changes=()
          while read -r line; do
            num=$(${pkgs.gawk}/bin/awk '{print $1}' <<< "$line")
            new_name=$(${pkgs.coreutils}/bin/cut -d' ' -f2- <<< "$line")
            old_name="''${original_files[$((num-1))]}"  # Adjust for 0-based index

            # Debug: Print the old and new names
            echo "Processing line: $line"
            echo "  Old name: $old_name"
            echo "  New name: $new_name"

            # Validate before adding to changes
            if [[ -n "$old_name" && -n "$new_name" && "$old_name" != "$new_name" ]]; then
              changes+=("mv -vn -- \"$old_name\" \"$new_name\"")
            fi
          done < "$tmpfile"

          # Debug: Print the changes array
          echo "Changes to be made:"
          printf '%s\n' "''${changes[@]}"

          # Show changes and confirm
          if [[ ''${#changes[@]} -eq 0 ]]; then
            lf -remote "send $id echo 'No changes to rename.'"
          else
            lf -remote "send $id echo 'The following changes will be made:'"
            for cmd in "''${changes[@]}"; do
              lf -remote "send $id echo '  $cmd'"
            done

            # Read confirmation from the terminal directly
            lf -remote "send $id echo -n 'Proceed? [y/N] '"
            read ans </dev/tty

            if [[ "$ans" == "y" || "$ans" == "Y" ]]; then
              for cmd in "''${changes[@]}"; do
                eval "$cmd"
              done
              lf -remote "send $id reload"
            else
              lf -remote "send $id echo 'Rename cancelled.'"
            fi
          fi

          # Clean up
          rm "$tmpfile"
        }}
      '';

      tar-create = ''
        ''${{
          printf "Archive name (without extension): "
          read NAME
          tar -czvf "$NAME.tar.gz" $fx
        }}
      '';

      cd-downloads = "cd ~/Downloads";
      cd-videos = "cd ~/Videos";
      cd-pix = "cd ~/Pictures";
      cd-dotfiles = "cd ~/dotfiles";
      cd-scripts = "cd ~/dotfiles/home/scripts";
      cd-programs = "cd ~/dotfiles/home/programs";
      cd-usb = "cd ~/mount/usb";
      file-open = ''&$OPENER "$f"'';
      extract = ''$extracto "$f"'';
    };
    keybindings = {
      "<enter>" = "$nvim $f";
      v = "editor-open";
      a = "mkdir";
      t = "touch";
      c = "clear";
      d = "delete";
      x = "cut";
      y = "copy";
      p = "paste";
      r = "rename";
      e = "extract";
      "." = "set hidden!";
      o = "open-terminal";
      gd = "cd-downloads";
      gu = "cd-usb";
      gs = "cd-scripts";
      gf = "cd-dotfiles";
      gp = "cd-programs";
      gv = "cd-videos";
      gx = "cd-pix";
      zz = "copy-path";
      br = "bulk-rename";
      zt = "tar-create";
    };
    settings = {
      preview = true;
      drawbox = true;
      icons = true;
      ignorecase = true;
    };
    extraConfig = let
      previewer = pkgs.writeShellScriptBin "pv.sh" ''
          case "$(${pkgs.file}/bin/file -Lb --mime-type -- "$1")" in
          application/pdf)
        ${pkgs.poppler_utils}/bin/pdftoppm -png -singlefile "$1" "/tmp/lf-pdf-preview" && \
        ${pkgs.chafa}/bin/chafa -f sixel -s "$2x$3" "/tmp/lf-pdf-preview.png"
        exit 1
          ;;
              application/zip|application/gzip|application/x-tar)
        ${pkgs.atool}/bin/atool -l "$1"
        ;;
            image/*)
              if [[ "$TERM" == "xterm-kitty" ]]; then
                file=$1
                w=$2
                h=$3
                x=$4
                y=$5

                if [[ "$(${pkgs.file}/bin/file -Lb --mime-type "$file")" =~ ^image ]]; then
                  ${pkgs.kitty}/bin/kitty +kitten icat --silent --stdin no --transfer-mode file \
                    --place "''${w}x''${h}@''${x}x''${y}" "$file" < /dev/null > /dev/tty
                  exit 1
                fi

                ${pkgs.pistol}/bin/pistol "$file"
              else
                ${pkgs.chafa}/bin/chafa -f sixel -s "$2x$3" --animate off --polite on "$1"
                exit 1
              fi
              ;;
            video/*)
              # Generate a thumbnail for video files using ffmpeg
              thumbnail="/tmp/lf-video-thumbnail.png"
              ${pkgs.ffmpeg}/bin/ffmpeg -y -i "$1" -vf "thumbnail" -frames:v 1 "$thumbnail" >/dev/null 2>&1

              if [[ "$TERM" == "xterm-kitty" ]]; then
                ${pkgs.kitty}/bin/kitty +kitten icat --silent --stdin no --transfer-mode file \
                  --place "''${2}x''${3}@''${4}x''${5}" "$thumbnail" < /dev/null > /dev/tty
              else
                ${pkgs.chafa}/bin/chafa -f sixel -s "$2x$3" --animate off --polite on "$thumbnail"
              fi
              rm "$thumbnail"
              exit 1
              ;;
            text/*)
              ${pkgs.bat}/bin/bat -pp --color always --wrap character -- "$1"
              ;;
          esac
      '';
      cleaner = pkgs.writeShellScriptBin "clean.sh" ''
        if [[ "$TERM" == "xterm-kitty" ]]; then
          ${pkgs.kitty}/bin/kitty +kitten icat --clear --stdin no --silent --transfer-mode file < /dev/null > /dev/tty
        else
          ${pkgs.killall}/bin/killall chafa 2>/dev/null
        fi
        ${pkgs.killall}/bin/killall bat 2>/dev/null
      '';
    in ''
      set sixel true
      set previewer ${previewer}/bin/pv.sh
      set cleaner ${cleaner}/bin/clean.sh
    '';
  };
}
