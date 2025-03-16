{pkgs, ...}: {
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    theme = ./mocha.rasi;
    terminal = "footclient";
  };
}
