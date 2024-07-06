{ config, pkgs, ... }:
{

  services.displayManager = {
    sessionPackages = [ pkgs.hyprland ];
    autoLogin.enable = true;
    autoLogin.user = "rey";
  };

  environment.systemPackages = with pkgs; [
    # other packages
  hyprpaper
  hyprlock
  hypridle
  hyprshot
  gtk3
  gtk4
  rofi-wayland
  waybar
      ];

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [xdg-desktop-portal-gtk xdg-desktop-portal-hyprland];
    config.preferred.default = ["hyprland" "gtk"];
    xdgOpenUsePortal = true;
  };

  # Environment variables
 # environment.variables = {
   # _JAVA_AWT_WM_NONREPARENTING = "1";    # For Java applications
   # QT_QPA_PLATFORM = "wayland";          # Enable Wayland support for Qt applications
    #XDG_SESSION_TYPE = "wayland";         # Set session type to Wayland
    #XDG_CURRENT_DESKTOP = "Hyprland";     # Set current desktop environment
    #XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config"; # XDG Config Home
  #};



  }
