rec {
  # Select Theme
  currentTheme = themes.catppuccin;
  theme = "catppuccin";

  # Console Colors (based on the current theme)
  console.colors = with currentTheme; [
    base00 # Background
    base01 # Lighter Background (e.g., status bars)
    base02 # Selection Background (e.g., highlighted text)
    base03 # Comments, Invisibles (e.g., disabled text)
    base04 # Dark Foreground (e.g., secondary text)
    base05 # Text, Default Foreground (e.g., primary text)
    base06 # Light Foreground (e.g., bold text)
    base07 # Light Background (e.g., tooltips)
    base08 # Variables, XML Tags (e.g., errors, warnings)
    base09 # Integers, Boolean, Constants (e.g., numbers)
    base0A # Classes, Markup Bold (e.g., keywords)
    base0B # Strings, Inherited Class (e.g., success messages)
    base0C # Support, Regular Expressions (e.g., hints)
    base0D # Functions, Methods, Headings (e.g., links)
    base0E # Active, Keywords, Storage, Selector (e.g., accents)
    base0F # Deprecated, Opening/Closing Embedded Language Tags
  ];

  # Git Configuration
  gitUsername = "Rouzihiro";
  gitEmail = "ryossj@gmail.com";

  # System Settings
  host = "HP"; # Hostname of the system
  shell = "bash"; # Default shell
  WM = "sway"; # Window Manager
  BT-status = false; # Bluetooth status (enabled/disabled)

  # Program Options
  browser = "brave"; # Default web browser
  #browser-light = "org.qutebrowser.qutebrowser"; # Lightweight browser
  browser-light = "librewolf"; # Lightweight browser
  terminal = "foot"; # Default terminal emulator
  launcher = "anyrun"; # Application launcher
  launcher2 = "wofi --menu"; # Alternative application launcher
  file-manager = "thunar"; # Graphical file manager
  Tfile-manager = "foot -e yazi"; # Terminal-based file manager
  imageViewer = "imv"; # Image viewer
  videoPlayer = "mpv"; # Video player
  Editor = "nvim"; # Text editor
  pdfViewer = "org.pwmt.zathura"; # PDF viewer
  audio-manager = "com.saivert.pwvucontrol"; # Audio control utility
  password-manager = "org.keepassxc.KeePassXC"; # Password manager
  bluetooth-manager = "io.github.kaii_lb.Overskride"; # Bluetooth manager

  # Keyboard and Locale Settings
  keyboardLayout = "de"; # Keyboard layout (German)
  consoleKeyMap = "de"; # Console keymap (German)
  clock24h = true; # Use 24-hour clock format
  timezone = "Europe/Berlin";
  locale = "en_US.UTF-8";

  # Theme Definitions
  themes = {
    nord = {
      base00 = "2E3440"; # Background
      base01 = "3B4252"; # Lighter Background
      base02 = "434C5E"; # Selection Background
      base03 = "4C566A"; # Comments, Invisibles
      base04 = "D8DEE9"; # Dark Foreground
      base05 = "E5E9F0"; # Text, Default Foreground
      base06 = "ECEFF4"; # Light Foreground
      base07 = "8FBCBB"; # Light Background
      base08 = "88C0D0"; # Variables, XML Tags
      base09 = "81A1C1"; # Selected, Integers, Boolean, Constants
      base0A = "5E81AC"; # Classes, Markup Bold
      base0B = "BF616A"; # Urgent, Strings, Inherited Class
      base0C = "D08770"; # Support, Regular Expressions
      base0D = "EBCB8B"; # Functions, Methods, Headings
      base0E = "A3BE8C"; # Active, Keywords, Storage, Selector
      base0F = "B48EAD"; # Deprecated, Opening/Closing Embedded Language Tags
    };

    catppuccin.macchiato = {
      base00 = "#24273a"; # Background
      base01 = "#1e2030"; # Lighter Background
      base02 = "#363a4f"; # Selection Background
      base03 = "#494d64"; # Comments, Invisibles
      base04 = "#5b6078"; # Dark Foreground
      base05 = "#cad3f5"; # Text, Default Foreground
      base06 = "#f4dbd6"; # Light Foreground
      base07 = "#b7bdf8"; # Light Background
      base08 = "#ed8796"; # Error
      base09 = "#f5a97f"; # Warning
      base0A = "#eed49f"; # Accent
      base0B = "#a6da95"; # Success
      base0C = "#8bd5ca"; # Secondary
      base0D = "#8aadf4"; # Primary
      base0E = "#c6a0f6"; # Secondary-alt
      base0F = "#f0c6c6"; # Deprecated
    };

    rose-pine = {
      base00 = "191724"; # Background
      base01 = "1f1d2e"; # Lighter Background
      base02 = "26233a"; # Selection Background
      base03 = "6e6a86"; # Comments, Invisibles
      base04 = "908caa"; # Dark Foreground
      base05 = "e0def4"; # Text, Default Foreground
      base06 = "e0def4"; # Light Foreground
      base07 = "524f67"; # Light Background
      base08 = "eb6f92"; # Variables, XML Tags
      base09 = "f6c177"; # Integers, Boolean, Constants
      base0A = "ebbcba"; # Classes, Markup Bold
      base0B = "31748f"; # Strings, Inherited Class
      base0C = "9ccfd8"; # Support, Regular Expressions
      base0D = "c4a7e7"; # Functions, Methods, Headings
      base0E = "c4a7e7"; # Active, Keywords, Storage, Selector
      base0F = "eb6f92"; # Deprecated, Opening/Closing Embedded Language Tags
    };

    catppuccin.frappe = {
      base00 = "303446"; # Background
      base01 = "292c3c"; # Lighter Background
      base02 = "414559"; # Selection Background
      base03 = "51576d"; # Comments, Invisibles
      base04 = "626880"; # Dark Foreground
      base05 = "c6d0f5"; # Text, Default Foreground
      base06 = "f2d5cf"; # Light Foreground
      base07 = "babbf1"; # Light Background
      base08 = "e78284"; # Error
      base09 = "ef9f76"; # Warning
      base0A = "e5c890"; # Accent
      base0B = "a6d189"; # Success
      base0C = "81c8be"; # Secondary
      base0D = "8caaee"; # Primary
      base0E = "ca9ee6"; # Active, Keywords, Storage, Selector
      base0F = "eebebe"; # Deprecated
    };

    catppuccin = {
      #mocha
      base00 = "#1e1e2e"; # Background
      base01 = "#181825"; # Lighter Background
      base02 = "#313244"; # Selection Background
      base03 = "#45475a"; # Comments, Invisibles
      base04 = "#585b70"; # Dark Foreground
      base05 = "#cdd6f4"; # Text, Default Foreground
      base06 = "#f5e0dc"; # Light Foreground
      base07 = "#b4befe"; # Light Background
      base08 = "#f38ba8"; # Error
      base09 = "#fab387"; # Warning
      base0A = "#f9e2af"; # Accent
      base0B = "#a6e3a1"; # Success
      base0C = "#94e2d5"; # Secondary
      base0D = "#89b4fa"; # Primary
      base0E = "#cba6f7"; # Active, Keywords, Storage, Selector
      base0F = "#f2cdcd"; # Deprecated
    };
  };
}
