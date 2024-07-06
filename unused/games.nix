{ config, pkgs, lib, ... }:
{
  # game related apps
  environment.systemPackages = with pkgs; [
    # antimicrox
    # appimage-run
    # discord
    cemu #GDK_BACKEND=x11 cemu #this makes sure it runs as x11 which solves problems in my case
    dolphin-emu
    dolphin-emu-primehack
    # dosbox
    gamemode
    #gamescope
    glibc #unclear if needed
    gtk3
    heroic
    libglvnd #unclear if needed
    libva-utils
    libvdpau-va-gl
    lutris
    mangohud
    mesa
    mesa-demos
    protonup-qt #run proton afterwards in terminal to install latest version
    # protontricks
    steam
    steam-run
    steamtinkerlaunch #afterwards run: steamtinkerlaunch compat add
    vaapiVdpau
    vkbasalt
    wine
    wineWowPackages.stable
    winetricks
    xdg-desktop-portal
    xdg-desktop-portal-gtk
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam"
    "steam-original"
    "steam-run"
  ];

  # Programs configuration
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };
  
  programs.gamescope.enable = true;
  programs.gamemode.enable = true;

  # Uncomment if needed
  # services.xdg.portal = {
  #   enable = true;
  #   backends = [ "gtk" ];
  # };
}

