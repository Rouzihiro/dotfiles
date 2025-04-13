{
  manual.manpages.enable = false;
  programs = {
    #fish.enable = true;
    #zsh.enable = false;
    bash.enable = true;

    #dircolors.enable = true;

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
