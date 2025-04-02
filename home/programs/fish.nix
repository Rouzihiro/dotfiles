{
  pkgs,
  lib,
  ...
}: let
  inherit (import ../../nixos/modules/variables.nix) host;

  myAliases = {
    # File and directory management
    ls = "eza --icons --grid --all --color=always";
    la = "eza --icons -l -T -L=1";
    tree2 = "eza -R";
    cat = "bat";
    md = "mkdir -pv";
    rm = "rm -Ivr";
    mv = "mv -iv";
    cp = "xcp -vr";
    crp = "rsync -ah --progress";
    df = "duf -hide special";
    mem = "free -h";

    # Navigation
    cd = "z";
    ".." = "cd ..";
    "..." = "cd ../..";
    ".3" = "cd ../../..";
    ".4" = "cd ../../../..";
    ".5" = "cd ../../../../..";

    # Editors
    v = "nvim";
    vi = "nvim";
    vim = "nvim";
    sv = "sudo nvim";

    # Git
    g = "git";
    gaa = "git add . -v";
    gc = "git commit -m";
    gct = "git commit";
    gs = "git status";
    gps = "git push -v";
    gpf = "git push -v --force";

    gf = "git fetch --all --tags --prune";
    gpl = "git pull";
    gpr = "git pull --rebase";

    gl = "git log --graph --oneline --decorate --all"; # Graphical log
    gls = "git log --stat"; # Log with stats
    gd = "git diff";
    gds = "git diff --stat";

    gco = "git checkout";
    gcb = "git checkout -b"; # Create and switch to a new branch
    gsw = "git switch";
    gm = "git merge";
    go = "git remote -v | grep github.com | grep fetch | head -1 | awk '{print $2}' | sed 's|git@github.com:|https://github.com/|' | xargs xdg-open";

    # Branching
    gb = "git branch";
    gba = "git branch -a"; # List all branches (local and remote)
    gbd = "git branch -d"; # Delete branch
    gbD = "git branch -D"; # Force delete branch

    # Rebasing
    grb = "git rebase";
    grba = "git rebase --abort";
    grbc = "git rebase --continue";
    grbi = "git rebase -i"; # Interactive rebase

    # Resetting
    grs = "git reset";
    grsh = "git reset --hard"; # Hard reset
    grst = "git restore --staged"; # Unstage changes

    lg = "cd ~/dotfiles && lazygit";
    sshz = "ssh-start";

    # System utilities
    ko = "pkill";
    h = "history | fzf";
    jour = "journalctl -xe";
    fz = "fzf --preview 'fzf-preview {}' --bind 'enter:execute(xdg-open {})'";
    openports = "netstat -nape --inet";
    myip = "curl https://ipinfo.io/ip && echo";
    ff = "clear && fastfetch";
    startup = "clear && systemctl list-unit-files --type=service | grep enabled";

    # NixOS
    update = "clear && cd ~/dotfiles && nix flake update";
    rebuild = "clear && nh os switch";
    rebuild2 = "clear && sudo nixos-rebuild switch --flake ~/dotfiles#${host}";
    ns = "nix-shell --command fish -p";

    # Dotfiles management
    edithome = "cd ~/dotfiles/home/ && nvim home.nix programs/packages2.nix";
    editsys = "cd ~/dotfiles/ && nvim hosts/modules/configuration.nix flake.nix";
    editzsh = "cd ~/dotfiles/home/programs && nvim zsh.nix";
    editfish = "cd ~/dotfiles/home/programs && nvim fish.nix";
    edithypr = "nvim ~/dotfiles/home/system/hyprland.nix";
    editsway = "nvim ~/dotfiles/home/system/sway.nix";
    editqtile = "nvim ~/dotfiles/home/system/qtile/src/config.py";
    nd = "nvim ~/dotfiles/";
    dots = "cd ~/dotfiles && ls";

    # Miscellaneous
    xx = "exit";
    c = "clear";
    o = "xdg-open";
    t = "tmux";
    yt1 = "yt-dlp --external-downloader aria2c --external-downloader-args 'aria2c:-x10 -s10 -k1M'";
    yt2 = "yt-dlp --external-downloader aria2c --external-downloader-args 'aria2c:-x10 -s10 -k1M' -o 'video_%(id)s.%(ext)s'";
    ytbest = "yt-dlp -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best'";
    ytx = "yt-x";
    wget1 = "wget --mirror --convert-links --adjust-extension --page-requisites --no-parent";
    wget2 = "wget --tries=5 --retry-connrefused --waitretry=30";
    curldl = "curl -L -C - -O";
    aria = "aria2c";

    fsource = "source ~/.config/fish/config.fish; echo 'Fish config reloaded!'";
  };

  # Import Fish functions
  fishFunctions = import ./fish-functions.nix {inherit pkgs;};
in {
  programs.fish = {
    enable = true;
    shellAliases = myAliases;

    shellInit = ''
                # Set GPG TTY
                set -gx GPG_TTY (tty)

                # Add custom scripts to PATH
                fish_add_path "$HOME/dotfiles/home/scripts"

                # Source Fish functions
                ${lib.concatStringsSep "\n" (lib.mapAttrsToList (name: path: "source ${path}") fishFunctions)}

                # Environment configuration
                set -g fish_greeting
                set -g theme_display_virtualenv yes
                set -g fish_prompt_pwd_dir_length 3
                set -g TRANSIENT_PROMPT 1  # Enable transient prompt by default

      # Syntax highlighting colors.
      set -g fish_color_autosuggestion 626262
      set -g fish_color_cancel 626262
      set -g fish_color_command 7cb3ff
      set -g fish_color_comment 949494 --italics
      set -g fish_color_cwd 87d787
      set -g fish_color_cwd_root ff5189
      set -g fish_color_end 949494
      set -g fish_color_error ff5454
      set -g fish_color_escape 949494
      set -g fish_color_history_current c6c6c6 --background=323437
      set -g fish_color_host e4e4e4
      set -g fish_color_host_remote e4e4e4
      set -g fish_color_keyword cf87e8
      set -g fish_color_match c6c6c6 --background=323437
      set -g fish_color_normal bdbdbd
      set -g fish_color_operator e65e72
      set -g fish_color_option bdbdbd
      set -g fish_color_param 61d5ae
      set -g fish_color_quote c6c684
      set -g fish_color_redirection 8cc85f
      set -g fish_color_search_match --background=323437
      set -g fish_color_selection --background=323437
      set -g fish_color_status ff5454
      set -g fish_color_user 36c692
      set -g fish_color_valid_path

      # Completion pager colors.
      set -g fish_pager_color_completion c6c6c6
      set -g fish_pager_color_description 949494
      set -g fish_pager_color_prefix 74b2ff
      set -g fish_pager_color_progress 949494
      set -g fish_pager_color_selected_background --background=323437
      set -g fish_pager_color_selected_completion e4e4e4
      set -g fish_pager_color_selected_description e4e4e4

                # History configuration (reduced to 10,000 entries)
                set -g fish_history permanent
                set -g history_size 10000
                set -g history_save 10000
                set -g history_merge on

                # Enhanced VCS configuration
                set -g __fish_git_prompt_show_informative_status 1
                set -g __fish_git_prompt_showupstream auto
                set -g __fish_git_prompt_char_stateseparator " "
                set -g __fish_git_prompt_char_cleanstate '✔'
                set -g __fish_git_prompt_char_conflictedstate '✖'
                set -g __fish_git_prompt_char_dirtystate '✚'
                set -g __fish_git_prompt_char_stagedstate '●'
                set -g __fish_git_prompt_char_untrackedfiles '…'
                set -g __fish_git_prompt_char_upstream_ahead '↑'
                set -g __fish_git_prompt_char_upstream_behind '↓'

                # Transient prompt hooks
                function __prompt_erase --on-event fish_preexec
                  if test "$TRANSIENT_PROMPT" = "1"
                    set -g TRANSIENT 1
                  end
                end
    '';
  };
}
