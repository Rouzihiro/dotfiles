{ pkgs, ... }: {
  home.file = {
    ".icons/theme_McMojave" = {
      source = ./static/theme_McMojave;
      recursive = true;
    };
  };

  home.pointerCursor = {
    name = "McMojave-cursors";
    size = 28;

    gtk.enable = true;
    x11.enable = true;

    package = pkgs.runCommand "mcmojave-cursors" {} ''
      mkdir -p $out/share/icons
      cp -r ${./static/McMojave-cursors} $out/share/icons/McMojave-cursors
    '';
  };
}

