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
      background = "#2E3440";
      foreground = "#D8DEE9";
      primary = "#81A1C1";
      secondary = "#5E81AC";
      accent = "#88C0D0";
    };

    rose-pine = {
      background = "#191724";
      foreground = "#e0def4";
      primary = "#9ccfd8";
      secondary = "#31748f";
      accent = "#c4a7e7";
    };
  
  };

}
