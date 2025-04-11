{pkgs, ...}: {
  programs.ladybird.enable = true;

  catppuccin = {
    enable = true;
    flavor = "macchiato";
    accent = "blue";
  };

  home.pointerCursor = {
    gtk.enable = true;
    #x11.enable = true;
    name = "Catppuccin-Macchiato-Dark-Cursors";
    package = pkgs.catppuccin-cursors.macchiatoDark;
    size = 24;
  };

  home = {
    packages = with pkgs; [
      nix-output-monitor
      #gnumake
      dconf
    ];
  };

  manual.manpages.enable = false;
  programs = {
    dircolors.enable = true;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableZshIntegration = true;
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
