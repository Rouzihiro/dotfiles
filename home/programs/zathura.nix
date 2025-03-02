{
  programs.zathura = {
    enable = true;

    options = {
      guioptions = "g";
      adjust-open = "width";
      statusbar-basename = true;
      render-loading = false;
      scroll-step = 120;
    };

    extraConfig = ''
      map b navigate previous
      map f navigate next
    '';
  };
}

