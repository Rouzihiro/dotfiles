{config, ...}: {
  manual.manpages.enable = false;
  programs = {
    bash.enable = true;
    fish.enable = false;
    zsh.enable = false;

    atuin = {
      enable = true;
      settings = {
        auto_sync = false;
        flags = ["--disable-up-arrow"];
        keymap_mode = "vim-insert";
        search_mode = "fuzzy";
        enter_accept = true;
        style = "compact";
        inline_height = 20;
        show_tabs = false;
        history_filter = ["tmp"];
        cwd_filter = ["/Downloads" "/tmp"];
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

    # Thefuck terminal correction
    thefuck = {
      enable = true;
      enableBashIntegration = config.programs.bash.enable;
      #enableZshIntegration = config.programs.zsh.enable or false;
      #enableNushellIntegration = config.programs.nushell.enable or false;
    };

    # Carapace shell completions
    carapace = {
      enable = true;
      enableBashIntegration = config.programs.bash.enable;
      #enableZshIntegration = config.programs.zsh.enable or false;
      #enableNushellIntegration = config.programs.nushell.enable or false;
    };
  };
}
