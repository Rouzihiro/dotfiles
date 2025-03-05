{pkgs}: let
  # Helper function to create a Fish script
  mkFishScript = name: script:
    pkgs.writeText "fish-function-${name}" ''
      function ${name}
        ${script}
      end
    '';
in {
  gitsync = mkFishScript "gitsync" ''
    # Stash any unstaged changes
    git stash push --include-untracked --message "Local changes stashed by gitsync"

    # Pull latest changes with rebase
    git pull --rebase origin main

    # Check if rebase resulted in conflicts
    if git rebase --show-current-patch >/dev/null 2>&1
        echo "Conflict detected! Resolve conflicts and then run 'git rebase --continue' (grbc)."
        echo "To abort the rebase, run 'git rebase --abort'."
        return 1
    end

    # Reapply stashed changes
    git stash pop

    echo "Sync complete!"
  '';

  ssh-start = mkFishScript "ssh-start" ''
    # Check if keychain is installed
    if not command -v keychain >/dev/null
        echo "Error: Please install keychain first"
        echo "For Debian/Ubuntu: sudo apt install keychain"
        echo "For Fedora: sudo dnf install keychain"
        echo "For macOS: brew install keychain"
        exit 1
    end

    # Configure keychain (modify as needed)
    set -l keychain_args --agents ssh --quiet

    # Load or start ssh-agent and add key
    keychain $keychain_args ~/.ssh/HP-Nixo
    source ~/.keychain/(hostname)-fish
  '';

  qrimg = mkFishScript "qrimg" ''
    qrencode -t png -r /dev/stdin -o /dev/stdout | convert - -interpolate Nearest -filter point -resize 1000% png:/dev/stdout
  '';

  compress = mkFishScript "compress" ''
    tar c -I"xz -T 0 -7" -f "$argv[1].tar.xz" "$argv[1]"
  '';

  archive = mkFishScript "archive" ''
    tar c -I"xz -T 0 -0" -f "$argv[1].tar.xz" "$argv[1]"
  '';

  ta = mkFishScript "ta" ''
    if test -z "$argv[1]"
      tmux attach
    else
      tmux attach -t "$argv[1]"
    end
  '';

  bwu = mkFishScript "bwu" ''
    set -x BW_SESSION (bw unlock --raw)
    bw sync
  '';

  findreplace = mkFishScript "findreplace" ''
    if test "$argv[1]" = "--help"
      echo "findreplace <trigger> <sed expression>"
      return
    end

    rg --files-with-matches "$argv[1]" | tee /dev/stderr | xargs sed -Ei "$argv[2]"
  '';

  cc = mkFishScript "cc" ''
    if contains -- --help $argv
      echo "Usage: cc [directory]"
      echo "Changes to the specified directory (or home if none) and lists contents."
      return 0
    end

    if test -n "$argv[1]"
      builtin cd "$argv[1]" && ls
    else
      builtin cd ~ && ls
    end
  '';

  cpz = mkFishScript "cpz" ''
    if contains -- --help $argv
      echo "Usage: cpz <source> <destination>"
      echo "Copies a file with a progress bar."
      return 0
    end

    if test (count $argv) -ne 2
      echo "Error: Source and destination are required."
      echo "Usage: cpz <source> <destination>"
      return 1
    end

    rsync --progress "$argv[1]" "$argv[2]"
  '';

  gitz = mkFishScript "gitz" ''
    if contains -- --help $argv
      echo "Usage: gitz [--force] <commit message>"
      echo "Adds all changes, commits, and pushes to the current branch."
      echo "Options:"
      echo "  --force   Force push the commit."
      return 0
    end

    if test -z "$argv[1]"
      echo "Error: Commit message is required."
      echo "Usage: gitz <commit message>"
      return 1
    end

    set -l commit_message
    set -l force_push false

    # Check for --force flag
    if contains -- --force $argv
      set force_push true
      set commit_message (string join " " -- $argv[2..-1])
    else
      set commit_message (string join " " -- $argv)
    end

    # Execute Git commands
    if git add .
      if git commit -m "$commit_message"
        if $force_push
          git push --force
        else
          git push
        end
      else
        echo "Error: Commit failed."
        return 1
      end
    else
      echo "Error: Git add failed."
      return 1
    end
  '';

  s = mkFishScript "s" ''
    if contains -- --help $argv
      echo "Usage: searchz <search term>"
      echo "Searches for text in files recursively."
      return 0
    end

    if test -z "$argv[1]"
      echo "Error: Search term is required."
      echo "Usage: searchz <search term>"
      return 1
    end
    grep --color=auto -rin "$argv[1]" .
  '';

  catz = mkFishScript "catz" ''
    if contains -- --help $argv
      echo "Usage: catz <file>"
      echo "Copies the content of a file to the clipboard."
      return 0
    end

    if test -z "$argv[1]"
      echo "Error: File is required."
      echo "Usage: catz <file>"
      return 1
    end
    wl-copy < "$argv[1]"
  '';

  fontz = mkFishScript "fontz" ''
    if contains -- --help $argv
      echo "Usage: fontz <font name>"
      echo "Searches for installed fonts matching the name."
      return 0
    end

    if test -z "$argv"
      echo "Error: Font name is required."
      echo "Usage: fontz <font name>"
      return 1
    end
    fc-list | grep --color=auto -i $argv[1]
  '';

  iso = mkFishScript "iso" ''
    if contains -- --help $argv
      echo "Usage: iso <iso file>"
      echo "Mounts an ISO file to ~/mount/iso."
      return 0
    end

    if test -z "$argv[1]"
      echo "Error: ISO file is required."
      echo "Usage: iso <iso file>"
      return 1
    end
    sudo mkdir -p ~/mount/iso
    sudo mount -o loop "$argv[1]" ~/mount/iso
  '';

  uniso = mkFishScript "uniso" ''
    if contains -- --help $argv
      echo "Usage: uniso"
      echo "Unmounts the ISO file from ~/mount/iso."
      return 0
    end

    sudo umount ~/mount/iso
  '';

  fish_prompt = mkFishScript "fish_prompt" ''
    # Save status first
    set -l last_status $status

    # Transient prompt logic
    if set -q TRANSIENT
      set -l symbol (set_color brgreen)"❯ "(set_color normal)
      echo -n $symbol
      set -e TRANSIENT
      return
    end

    # User/host context (change color if SSH)
    set -l user_host_color brcyan
    if set -q SSH_CLIENT
      set user_host_color yellow
    end
    set -l user_host (set_color $user_host_color)(prompt_login)(set_color normal)

    # Path component with write detection
    set -l path_color green
    if not test -w (pwd)
      set path_color red
    end
    set -l path (set_color $path_color)(prompt_pwd)(set_color normal)
    if not test -w (pwd)
      set path "$path "(set_color red)"🔒"
    end

    # VCS info with custom symbols
    set -l vcs (set_color magenta)(fish_vcs_prompt " (%s)")(set_color normal)

    # Status code
    set -l stat (set_color red)(test $last_status -ne 0 && echo "[$last_status] ")(set_color normal)

    # Root symbol
    set -l symbol "❯"
    if fish_is_root_user
        set symbol "#"
    end

    # Combine components
    echo -n $user_host $path $vcs $stat
    echo -n (set_color brgreen)"$symbol "(set_color normal)
  '';

  fish_right_prompt = mkFishScript "fish_right_prompt" ''
    # Python virtualenv
    if set -q VIRTUAL_ENV
        echo -n (set_color cyan)"("(basename $VIRTUAL_ENV)") "(set_color normal)
    end

    # Command duration (in minutes)
    if test $CMD_DURATION
      and test $CMD_DURATION -gt 500
      set -l duration (echo "$CMD_DURATION 60000" | awk '{printf "%.1fm", $1/$2}')
      echo -n (set_color yellow)"$duration "(set_color normal)
    end

    # Time stamp (hours and minutes only)
    echo -n (set_color yellow)(date "+%H:%M")(set_color normal)
  '';

  # Optional: Add fish_mode_prompt if you use vi-mode in Fish
  fish_mode_prompt = mkFishScript "fish_mode_prompt" ''
    # Add your vi-mode prompt logic here if needed
  '';
}
