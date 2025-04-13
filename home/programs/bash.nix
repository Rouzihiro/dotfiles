{pkgs, ...}: let
  inherit (import ../../nixos/modules/variables.nix) host;

  bashFunctions = builtins.readFile ./../scripts/bash_functions;

  nixBashFunctions = pkgs.writeText "bash-functions" ''
    # Load Nix environment first
    [ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ] && \
      source "$HOME/.nix-profile/etc/profile.d/nix.sh"

    ${bashFunctions}

    # Export all functions after definition
    export -f $(grep -E '^[a-zA-Z0-9_]+\(\)' ${pkgs.writeText "temp" bashFunctions} |
                cut -d'(' -f1 | tr '\n' ' ')
  '';

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
    gl = "git log --graph --oneline --decorate --all";
    gls = "git log --stat";
    gd = "git diff";
    gds = "git diff --stat";
    gco = "git checkout";
    gcb = "git checkout -b";
    gsw = "git switch";
    gm = "git merge";
    go = "git remote -v | grep github.com | grep fetch | head -1 | awk '{print $2}' | sed 's|git@github.com:|https://github.com/|' | xargs xdg-open";
    gb = "git branch";
    gba = "git branch -a";
    gbd = "git branch -d";
    gbD = "git branch -D";
    grb = "git rebase";
    grba = "git rebase --abort";
    grbc = "git rebase --continue";
    grbi = "git rebase -i";
    grs = "git reset";
    grsh = "git reset --hard";
    grst = "git restore --staged";
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
    rebuild3 = "clear && sudo nixos-rebuild switch --flake ~/dotfiles#${host} --show-trace";
    ns = "nix-shell --command bash -p";

    # Dotfiles management
    edithome = "cd ~/dotfiles/home/ && nvim home.nix programs/packages2.nix";
    editsys = "cd ~/dotfiles/ && nvim hosts/modules/configuration.nix flake.nix";
    editzsh = "cd ~/dotfiles/home/programs && nvim zsh.nix";
    editfish = "cd ~/dotfiles/home/programs && nvim fish.nix";
    edithypr = "nvim ~/dotfiles/home/system/hyprland.nix";
    editsway = "nvim ~/dotfiles/home/system/sway.nix";
    editi3 = "nvim ~/dotfiles/home/system/i3.nix";
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
    ufda = "echo 'use flake' | tee .envrc && direnv allow";
  };
in {
  home.file.".bash_functions".text = bashFunctions;

  programs.bash = {
    shellAliases = myAliases;
    enableCompletion = true;
    enableVteIntegration = true;
    initExtra = ''
      export PATH="$HOME/dotfiles/home/scripts:$PATH"
          source ${nixBashFunctions}

          # Key bindings
          bind 'set colored-stats On'
          bind 'set colored-completion-prefix On'
          bind 'set show-all-if-ambiguous on'
          bind 'set completion-ignore-case on'
          bind 'set echo-control-characters off'
          bind '"\e[A": history-search-backward'
          bind '"\e[B": history-search-forward'
          bind '"\e[1;5D": backward-word'
          bind '"\e[1;5C": forward-word'
          bind '"\C-f": "cd ~/.config/\n"'
          bind '"\C-b": "cd ..\n"'
          bind '"\C-h": "cd\n"'
          bind '"\C-w": "webserver\n"'
          bind '"\es": "\C-asudo \C-e"'

          # History configuration
          HISTSIZE=10000
          HISTFILESIZE=10000
          shopt -s histappend
          shopt -s cmdhist

          # Direnv integration
          eval "$(${pkgs.direnv}/bin/direnv hook bash)"

          # Zoxide initialization
          eval "$(${pkgs.zoxide}/bin/zoxide init bash)"

          # FZF integration
          source ${pkgs.fzf}/share/fzf/key-bindings.bash
    '';
  };

  programs.atuin = {
    enable = true;
    settings = {
      auto_sync = false;
      keymap_mode = "vim-insert";
    };
  };
}
