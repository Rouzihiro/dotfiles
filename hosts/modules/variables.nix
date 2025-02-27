rec {

  # Select Theme
  currentTheme = themes.nord; 
  theme = "nord";

  gitUsername = "Rouzihiro";
  gitEmail = "ryossj@gmail.com";

  # Hyprland Settings
  extraMonitorSettings = "";

  # System Settings
  host = "HP";
  shell = "fish";
  xdg = "xdg-desktop-portal-hyprland";
  WM = "hyprland";
  BT-status = false;

  # Program Options
  browser = "brave"; 
  browser-light = "qutebrowser";
  terminal = "foot";
  launcher = "wofi --menu";
  file-manager = "nautilus";
  Tfile-manager = "foot -e yazi";
  imageViewer = "imv";
  videoPlayer = "mpv";
  Editor = "nvim";
  pdfViewer = "org.pwmt.zathura";
  audio-manager = "com.saivert.pwvucontrol";
  password-manager = "org.keepassxc.KeePassXC";
  bluetooth-manager = "io.github.kaii_lb.Overskride";

  keyboardLayout = "de";
  consoleKeyMap = "de";
  clock24h = true;

 
  themes = {

nord = {
      base00 = "2E3440";
      base01 = "3B4252";
      base02 = "434C5E";
      base03 = "4C566A";
      base04 = "D8DEE9";
      base05 = "E5E9F0";
      base06 = "ECEFF4";
      base07 = "8FBCBB";
      base08 = "88C0D0";
      base09 = "81A1C1";
      base0A = "5E81AC";
      base0B = "BF616A";
      base0C = "D08770";
      base0D = "EBCB8B";
      base0E = "A3BE8C";
      base0F = "B48EAD";
    };

  nord-light = {
  base00 = "#e5e9f0";
  base01 = "#c2d0e7";
  base02 = "#b8c5db";
  base03 = "#aebacf";
  base04 = "#60728c";
  base05 = "#2e3440";
  base06 = "#3b4252";
  base07 = "#29838d";
  base08 = "#99324b";
  base09 = "#ac4426";
  base0A = "#9a7500";
  base0B = "#4f894c";
  base0C = "#398eac";
  base0D = "#3b6ea8";
  base0E = "#97365b";
  base0F = "#5272af";
};

    rose-pine = {
      base00 = "191724";
      base01 = "1f1d2e";
      base02 = "26233a";
      base03 = "6e6a86";
      base04 = "908caa";
      base05 = "e0def4";
      base06 = "e0def4";
      base07 = "524f67";
      base08 = "eb6f92";
      base09 = "f6c177";
      base0A = "ebbcba";
      base0B = "31748f";
      base0C = "9ccfd8";
      base0D = "c4a7e7";
      base0E = "f6c177";
      base0F = "524f67";
    };

    io = {
      base00 = "1a181a";
      base01 = "262326";
      base02 = "302c30";
      base03 = "373238";
      base04 = "463f47";
      base05 = "bfaab7";
      base06 = "dbd7da";
      base07 = "faf7f9";
      base08 = "de5b44";
      base09 = "e39755";
      base0A = "a84a73";
      base0B = "c965bf";
      base0C = "9c5fce";
      base0D = "0e85b9";
      base0E = "6ac38f";
      base0F = "a3ab5a";
    };
  };

}
