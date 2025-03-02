{pkgs, ...}:
pkgs.writeShellScriptBin "keybinds-shell" ''

  yad --width=800 --height=650 \
    --center \
    --fixed \
    --title="Shell Keybindings" \
    --no-buttons \
    --list \
    --column=Key: \
    --column=Description: \
    --column=Command: \
    --timeout=90 \
    --timeout-indicator=right \
    "ls" "List files with icons" "eza --icons --grid --all --color=always" \
    "la" "List files with details" "eza --icons -l -T -L=1" \
    "tree2" "List files recursively" "eza -R" \
    "cat" "Show file contents" "bat" \
    "v" "Edit with Neovim" "nvim" \
    "sv" "Edit with Neovim (sudo)" "sudo nvim" \
    "zsource" "Source ZSH config" "source ~/.zshrc" \
    "g" "Git command" "git" \
    "xx" "Exit shell" "exit" \
    "cd" "Change directory with z" "z" \
    ".." "Move up a directory" "cd .." \
    "..." "Move up two directories" "cd ../.." \
    ".3" "Move up three directories" "cd ../../.." \
    "md" "Create directory" "mkdir -pv" \
    "HP" "Rebuild system with HP configuration" "sudo nixos-rebuild switch --flake .#HP" \
    "crp" "Copy files with rsync" "rsync -ah --progress" \
    "rm" "Remove files with confirmation" "rm -Ivr" \
    "mv" "Move files with confirmation" "mv -iv" \
    "cp" "Copy files with xcp" "xcp -vr" \
    "c" "Clear terminal" "clear" \
    "df" "Disk usage report" "duf -hide special" \
    "mem" "Memory report" "free -h" \
    "ko" "Kill process" "pkill" \
    "h" "Search history with fzf" "history | fzf" \
    "fz" "Search with fzf" "fzf --preview 'fzf-preview {}' --bind 'enter:execute(xdg-open {})'" \
    "yt" "YouTube downloader" "yt-x" \
    "edithome" "Edit home.nix" "cd ~/dotfiles/home/  nvim home.nix programs/packages2.nix" \
    "editsys" "Edit system configuration" "cd ~/dotfiles/  nvim hosts/modules/configuration.nix flake.nix" \
    "editshell" "Edit shell configuration" "cd ~/dotfiles/home/programs  nvim zsh.nix shell.nix" \
    "edithypr" "Edit Hyprland configuration" "nvim ~/dotfiles/home/system/hyprland.nix" \
    "editsway" "Edit Sway configuration" "nvim ~/dotfiles/home/system/sway.nix" \
    "sc" "Browse scripts" "~/dotfiles/home/scripts/browse-scripts" \
    "vid" "Browse videos" "~/dotfiles/home/scripts/browser-videos" \
    "fetch" "Fastfetch system info" "clear  fastfetch" \
    "startup" "List enabled services" "clear  systemctl list-unit-files --type=service | grep enabled" \
    "clean" "Clean NixOS garbage" "clear  sudo nix-collect-garbage -d  nix-store --gc  sudo nix-env --delete-generations old  sudo nix profile wipe-history --profile /nix/var/nix/profiles/system" \
    "ncg" "Clean NixOS configuration" "clear  nh clean all  sudo bootctl cleanup " \
    "update" "Update dotfiles" "clear  nix flake update ~/dotfiles" \
    "rebuild" "Rebuild system" "clear  sudo nixos-rebuild switch --flake ~/dotfiles#HP" \
    "ns" "Start Nix shell" "nix-shell --command zsh -p" \
    "nd" "Edit dotfiles" "nvim ~/dotfiles/" \
    "lg" "Launch LazyGit" "cd ~/dotfiles lazygit" \
    "s" "Search for text inside files" "grep --color=auto -rin" \
    "cc" "Copy file text to clipboard" "cat $1 wl-copy"
''
