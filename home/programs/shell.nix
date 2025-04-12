{
  programs = {
		#fish.enable = true;
    #zsh.enable = false;
    bash.enable = true;

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
