{...}: {
  home.file = {
    ".icons/theme_McMojave" = {
      source = ./static/theme_McMojave;
      recursive = true;
    };
    ".icons/McMojave-cursors" = {
      source = ./static/McMojave-cursors;
      recursive = true;
    };
    cursorTheme = {
      name = "McMojave-cursors";
      size = 28;
    };
  };
}
