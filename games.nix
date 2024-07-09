{ config, pkgs, lib, ... }:
{
  # Game-related packages
  environment.systemPackages = with pkgs; [
    # antimicrox
    # appimage-run
    discord
    cemu  # Ensure it runs with X11 backend if needed
    dolphin-emu
    dolphin-emu-primehack
    # dosbox
    # gamemode
    # gamescope
    # glibc  # Unclear if needed
    glxinfo
    # gtk3
    heroic
    # libglvnd  # Unclear if needed
    # libva-utils
    # libvdpau-va-gl
    lutris
    # mangohud
    # mesa
    # mesa-demos
    protonup-qt  # Run Proton afterwards in terminal to install latest version
    protontricks
    steam
    steam-run
    steamtinkerlaunch  # Afterwards run: steamtinkerlaunch compat add
    # vaapiVdpau
    vkbasalt  # Vulkan post-processing layer for improved visuals
    wine
    wineWowPackages.stable
    winetricks
    xdg-desktop-portal
    xdg-desktop-portal-gtk
  ];

  # Allow unfree packages (Steam-related)
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam"
    "steam-original"
    "steam-run"
  ];

  # Programs configuration
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;  # Enable GameScope for Steam games
  };

  programs.gamescope.enable = true;  # Enable GameScope globally
  programs.gamemode.enable = true;   # Enable GameMode for better performance

  # Additional tweaks
  hardware.graphics.enable32Bit = true;  # Enable 32-bit support for OpenGL
  hardware.graphics.enable = true;  # Enable OpenGL support for games

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

