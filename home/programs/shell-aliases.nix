{
  hostname,
  ...
}: {
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
  folders = "du -h --max-depth=1";

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
  rebuild2 = "clear && sudo nixos-rebuild switch --flake ~/dotfiles#${hostname}";
  rebuild3 = "clear && sudo nixos-rebuild switch --flake ~/dotfiles#${hostname} --show-trace";
	ns = "nix-shell --run '$(ps -p $$ -o comm=)' -p";
  list-gen = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system/";
  find-store-path = ''function { nix-shell -p $1 --command "nix eval -f "<nixpkgs>" --raw $1" }'';

  # Dotfiles management
  home-cfg = "cd ~/dotfiles/home/ && nvim home.nix programs/packages2.nix";
  sys-cfg = "cd ~/dotfiles/ && nvim hosts/modules/configuration.nix flake.nix";
  bash-cfg = "nvim ~/dotfiles/home/programs/bash";
  zsh-cfg = "nvim ~/dotfiles/home/programs/zsh.nix";
  fish-cfg = "nvim ~/dotfiles/home/programs/fish.nix";
  hypr-cfg = "nvim ~/dotfiles/home/system/hyprland.nix";
  sway-cfg = "nvim ~/dotfiles/home/system/sway.nix";
  i3-cfg = "nvim ~/dotfiles/home/system/i3.nix";
  qtile-cfg = "nvim ~/dotfiles/home/system/qtile/src/config.py";
  nd = "nvim ~/dotfiles/";
  dots = "cd ~/dotfiles && ls";

  # Miscellaneous
	sbash = "source ~/.bashrc";
  xargs = "xargs ";
  sudo = "sudo ";
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
}
