{lib, ...}: {
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        opacity = lib.mkForce 0.8;
        #decorations = "none";
        padding = {
          x = 5;
          y = 5;
        };
      };
    };
  };
}
