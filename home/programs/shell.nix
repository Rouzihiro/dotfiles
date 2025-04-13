{
  manual.manpages.enable = false;
  programs = {
    bash.enable = true;
    fish.enable = false;
    zsh.enable = false;

    atuin = {
      enable = true;
      settings = {
        auto_sync = false;
        keymap_mode = "vim-insert";
      };
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
      #enableZshIntegration = true;
    };

    #feh.enable = true;
    zoxide = {
      enable = true;
      #enableZshIntegration = true;
    };

    bat.enable = true;
    fzf.enable = true;
    eza = {
      enable = true;
      extraOptions = [
        "--group-directories-first"
        "--header"
        "--icons"
      ];
    };
  };
}
