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
  browser-light = "org.qutebrowser.qutebrowser";
  terminal = "foot";
  launcher = "anyrun";
  #launcher = "wofi --menu";
  file-manager = "thunar";
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
  base00 = "2E3440";  # Background
  base01 = "3B4252";  # Lighter Background
  base02 = "434C5E";  # Selection Background
  base03 = "4C566A";  # Comments, Invisibles
  base04 = "D8DEE9";  # Dark Foreground
  base05 = "E5E9F0";  # Default Foreground
  base06 = "ECEFF4";  # Light Foreground
  base07 = "8FBCBB";  # Light Background
  base08 = "88C0D0";  # Variables, XML Tags
  base09 = "81A1C1";  # Integers, Boolean, Constants
  base0A = "5E81AC";  # Classes, Markup Bold
  base0B = "BF616A";  # Strings, Inherited Class
  base0C = "D08770";  # Support, Regular Expressions
  base0D = "EBCB8B";  # Functions, Methods, Headings
  base0E = "A3BE8C";  # Keywords, Storage, Selector
  base0F = "B48EAD";  # Deprecated, Opening/Closing Embedded Language Tags
};

rose-pine = {
  base00 = "191724";  # Background
  base01 = "1f1d2e";  # Lighter Background
  base02 = "26233a";  # Selection Background
  base03 = "6e6a86";  # Comments, Invisibles
  base04 = "908caa";  # Dark Foreground
  base05 = "e0def4";  # Default Foreground
  base06 = "e0def4";  # Light Foreground
  base07 = "524f67";  # Light Background
  base08 = "eb6f92";  # Variables, XML Tags
  base09 = "f6c177";  # Integers, Boolean, Constants
  base0A = "ebbcba";  # Classes, Markup Bold
  base0B = "31748f";  # Strings, Inherited Class
  base0C = "9ccfd8";  # Support, Regular Expressions
  base0D = "c4a7e7";  # Functions, Methods, Headings
  base0E = "c4a7e7";  # Keywords, Storage, Selector
  base0F = "eb6f92";  # Deprecated, Opening/Closing Embedded Language Tags
};

  };

}
