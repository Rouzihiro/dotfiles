rec {
  # Select Theme
  currentTheme = themes.catppuccin;
  theme = "catppuccin";

  console.colors = with currentTheme; [
    base00
    base01
    base02
    base03
    base04
    base05
    base06
    base07
    base08
    base09
    base0A
    base0B
    base0C
    base0D
    base0E
    base0F
  ];

  gitUsername = "Rouzihiro";
  gitEmail = "ryossj@gmail.com";

  # System Settings
  host = "HP";
  shell = "fish";
  WM = "sway";
  BT-status = true;

  # Program Options
  browser = "brave";
  browser-light = "org.qutebrowser.qutebrowser";
  terminal = "foot";
  launcher = "anyrun";
  launcher2 = "wofi --menu";
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

    catppuccin.macchiato = {
      #macchiato
      base00 = "#24273a";
      base01 = "#1e2030";
      base02 = "#363a4f";
      base03 = "#494d64";
      base04 = "#5b6078";
      base05 = "#cad3f5";
      base06 = "#f4dbd6";
      base07 = "#b7bdf8";
      base08 = "#ed8796";
      base09 = "#f5a97f";
      base0A = "#eed49f";
      base0B = "#a6da95";
      base0C = "#8bd5ca";
      base0D = "#8aadf4";
      base0E = "#c6a0f6";
      base0F = "#f0c6c6";
    };

    rose-pine = {
      base00 = "191724"; # Background
      base01 = "1f1d2e"; # Lighter Background
      base02 = "26233a";
      base03 = "6e6a86"; # Comments, Invisibles
      base04 = "908caa"; # Dark Foreground
      base05 = "e0def4"; # Default Foreground
      base06 = "e0def4"; # Light Foreground
      base07 = "524f67"; # Light Background
      base08 = "eb6f92"; # Variables, XML Tags
      base09 = "f6c177"; # Integers, Boolean, Constants
      base0A = "ebbcba"; # Classes, Markup Bold
      base0B = "31748f"; # Strings, Inherited Class
      base0C = "9ccfd8"; # Support, Regular Expressions
      base0D = "c4a7e7"; # Functions, Methods, Headings
      base0E = "c4a7e7"; # Keywords, Storage, Selector
      base0F = "eb6f92"; # Deprecated, Opening/Closing Embedded Language Tags
    };

    dracula = {
      base00 = "282a36";
      base01 = "343746";
      base02 = "424450";
      base03 = "6272a4";
      base04 = "f8f8f2";
      base05 = "f8f8f2";
      base06 = "f8f8f2";
      base07 = "6272a4";
      base08 = "ff5555";
      base09 = "ff79c6";
      base0A = "f1fa8c";
      base0B = "50fa7b";
      base0C = "8be9fd";
      base0D = "bd93f9";
      base0E = "ffb86c";
      base0F = "ff5555";
    };

    catppuccin.frappe = {
      #frappe
      base00 = "303446";
      base01 = "292c3c";
      base02 = "414559";
      base03 = "51576d";
      base04 = "626880";
      base05 = "c6d0f5";
      base06 = "f2d5cf";
      base07 = "babbf1";
      base08 = "e78284";
      base09 = "ef9f76";
      base0A = "e5c890";
      base0B = "a6d189";
      base0C = "81c8be";
      base0D = "8caaee";
      base0E = "ca9ee6";
      base0F = "eebebe";
    };

    catppuccin = {
      # mocha
      base00 = "#1e1e2e";
      base01 = "#181825";
      base02 = "#313244";
      base03 = "#45475a";
      base04 = "#585b70";
      base05 = "#cdd6f4";
      base06 = "#f5e0dc";
      base07 = "#b4befe";
      base08 = "#f38ba8";
      base09 = "#fab387";
      base0A = "#f9e2af";
      base0B = "#a6e3a1";
      base0C = "#94e2d5";
      base0D = "#89b4fa";
      base0E = "#cba6f7";
      base0F = "#f2cdcd";
    };
    moonfly = {
      # Moonfly Theme
      base00 = "#323437"; # color0
      base01 = "#ff5454"; # color1
      base02 = "#8cc85f"; # color2
      base03 = "#e3c78a"; # color3
      base04 = "#80a0ff"; # color4
      base05 = "#cf87e8"; # color5
      base06 = "#79dac8"; # color6
      base07 = "#c6c6c6"; # color7
      base08 = "#949494"; # color8
      base09 = "#ff5189"; # color9
      base0A = "#36c692"; # color10
      base0B = "#c6c684"; # color11
      base0C = "#74b2ff"; # color12
      base0D = "#ae81ff"; # color13
      base0E = "#85dc85"; # color14
      base0F = "#e4e4e4"; #color15
      selection_background = "#b2ceee";
      selection_foreground = "#080808";
      active_tab_foreground = "#080808";
      active_tab_background = "#80a0ff";
      inactive_tab_foreground = "#b2b2b2";
      inactive_tab_backgroud = "#323437";
      active_border_color = "#80a0ff";
      inactive_borer_color = "#323437";
      background = "#080808";
      foregroud = "#bdbdbd";
      cursor = "9e9e9e";
      url_color = "#79dac8";
    };
  };
}
