{
  programs = {
    zsh.enable = false;
    bash.enable = false;

    bat.enable = true;
    fzf.enable = true;
    zoxide.enable = true;

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
