{...}: let
  myAliases = {
    ls = "eza --icons --grid --all --color=always";
    la = "eza --icons -l -T -L=1";
    tree2 = "eza -R";
    cat = "bat";
    v = "nvim";
    sv = "sudo nvim";
    zsource = "source ~/.zshrc";
    g = "git";
    #hlog = "journalctl -u hyprland --since '10 minutes ago'";
    xx = "exit";
    cd = "z";
    ".." = "cd ..";
    "..." = "cd ../..";
    ".3" = "cd ../../..";
    ".4" = "cd ../../../..";
    ".5" = "cd ../../../../..";
    md = "mkdir -pv";
    HP = "sudo nixos-rebuild switch --flake .#HP";
    crp = "rsync -ah --progress";
    rm = "rm -Ivr";
    mv = "mv -iv";
    cp = "xcp -vr";
    c = "clear";
    df = "duf -hide special";
    mem = "free -h";
    ko = "pkill";
    h = "history | fzf";

    fz = "fzf --preview 'fzf-preview {}' --bind 'enter:execute(xdg-open {})'";
    openports = "netstat -nape --inet";
    yt = "yt-x";

    iso = "function _iso(){ sudo mkdir -p ~/mount/iso && sudo mount -o loop '$1' ~/mount/iso; }; _iso";
    uniso = "sudo umount ~/mount/iso";

    edithome = "cd ~/dotfiles/home/ && nvim home.nix programs/packages2.nix";
    editsys = "cd ~/dotfiles/ && nvim hosts/modules/configuration.nix flake.nix";
    editshell = "cd ~/dotfiles/home/programs && nvim zsh.nix shell.nix";
    edithypr = "nvim ~/dotfiles/home/system/hyprland.nix";
    editsway = "nvim ~/dotfiles/home/system/sway.nix";
    editqtile = "nvim ~/dotfiles/home/system/qtile/src/config.py";

    sc = "~/dotfiles/home/scripts/browse-scripts";
    vid = "~/dotfiles/home/scripts/browse-videos";

    # System
    fetch = "clear && fastfetch";
    startup = "clear && systemctl list-unit-files --type=service | grep enabled";

    # NixOS
    clean = "clear && sudo nix-collect-garbage -d && nix-store --gc && sudo nix-env --delete-generations old && sudo nix profile wipe-history --profile /nix/var/nix/profiles/system && sudo rm -rf /var/log/journal/*";
    # nrs = "clear && nh os switch";
    # nfu = "clear && nh os switch --update";
    ncg = "clear && nh clean all && sudo bootctl cleanup ";
    update = "clear && cd ~/dotfiles && nix flake update";
    rebuild = "clear && nh os switch";
    rebuild2 = "clear && sudo nixos-rebuild switch --flake ~/dotfiles#HP";

    # Dev
    ns = "nix-shell --command zsh -p";
    nd = "nvim ~/dotfiles/";
    lg = "cd ~/dotfiles && lazygit";
  };
in {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autocd = true;
    autosuggestion = {enable = true;};
    syntaxHighlighting = {enable = true;};
    sessionVariables = {
      PROMPT_EOL_MARK = "󱞥";
    };
    shellAliases = myAliases;
    initExtra = ''
          autoload -U compinit && compinit
          zstyle ':completion:*' menu select
          zstyle ':completion:*' list-rows-first true
      cc ()
      {
      	if [ -n "$1" ]; then
      		builtin cd "$@" && ls
      	else
      		builtin cd ~ && ls
      	fi
      }
            cpp() {
              set -e
              strace -q -ewrite cp -- "\''${1}" "\''${2}" 2>&1 |
              awk -v total_size="$(stat -c '%s' "\''${1}")" '
              {
                count += $NF
                if (count % 10 == 0) {
                  percent = count / total_size * 100
                  printf "%3d%% [", percent
                  for (i=0; i<=percent; i++) printf "="
                  printf ">"
                  for (i=percent; i<100; i++) printf " "
                  printf "]\r"
                }
              }
              END { print "" }'
            }

            gh() {
              if [ -z "$1" ]; then
                echo "Error: Commit message is required"
                return 1
              fi
              git add .
              git commit -m "$1"
              git push
            }
            s() {
              grep --color=auto -rin "$1" .
              }

            ct() {
              cat "$1" | wl-copy
              }

          font() {
            fc-list | grep --color=auto -i "$@"
            }


                export STARSHIP_CONFIG="$HOME/.config/starship.toml"
              if command -v starship &> /dev/null; then
                eval "$(starship init zsh)"
              fi
             export PATH="$HOME/dotfiles/home/scripts:$PATH"
             export GPG_TTY=$(tty)

          # Start SSH agent and add the private key if not already loaded
          if ! pgrep -u $USER ssh-agent > /dev/null; then
            eval "$(ssh-agent -s)"
            ssh-add ~/.ssh/HP-Nixo
          fi
    '';
    history = {size = 10000;};
  };
}
