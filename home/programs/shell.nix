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
        filter_mode = "global";
        filters = [
          "^gs$"
          "^ga$"
          "^fz$"
          "^lf$"
          "^cd ~/dotfiles; clear; ls$"
          "^cd /home/rey/dotfiles/home/docs/tasks; clear; ls$"
          "^cd /home/rey/dotfiles/home/docs/tasks; nvim README.md$"
          "^cd dotfiles$"
          "^cd home/scripts$"
          "^rebuild2$"
          "^rey-doc$"
          "^ls$"
        ];
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
