{ config, pkgs, lib, ... }:
{
  # Game-related packages
  environment.systemPackages = with pkgs; [
    # antimicrox
    # appimage-run
    dbus
    cemu  # Ensure it runs with X11 backend if needed
    dolphin-emu
    dolphin-emu-primehack
    # dosbox
    gamemode
    gamepad-tool
    gamescope
    glibc  
    glxinfo
    heroic
    libglvnd  
    libva-utils
    libvdpau-va-gl
    lutris
    mangohud
    mesa
    mesa-demos
    openssl_1_1
    protonup-qt  # Run Proton afterwards in terminal to install latest version
    protontricks
    steam
    steam-run
    #steamtinkerlaunch  # Afterwards run: steamtinkerlaunch compat add
    #suyu
    vaapiVdpau
    vkbasalt  # Vulkan post-processing layer for improved visuals
    wineWowPackages.stable #https://nixos.wiki/wiki/Wine
    winetricks
    #xdg-desktop-portal
    #xdg-desktop-portal-gtk
  ];

  # Allow unfree packages (Steam-related)
 # nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
 #   "steam"
 #   "steam-original"
 #   "steam-run"
 # ];

  # Programs configuration
  #programs.steam = {
  #  enable = true;
   # gamescopeSession.enable = false;  # Enable GameScope for Steam games
  #};

 #programs.gamescope.enable = true;  # Enable GameScope globally
 #programs.gamemode.enable = true;   # Enable GameMode for better performance
# 
 #services.dbus.enable = true;


  # Enable MangoHud for overlay with game performance metrics
  # services.mangohud = {
  #   enable = true;
  #   perAppConfig = {
  #     "steam" = {
  #       configFile = "mangohud.conf";
  #     };
  #   };
  # };


}

