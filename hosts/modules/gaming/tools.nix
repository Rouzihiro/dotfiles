{ config, pkgs, lib, ... }:
{
  # Game-related packages
  environment.systemPackages = with pkgs; [
    # antimicrox
    # appimage-run
    # dbus
    # cemu  # Ensure it runs with X11 backend if needed
    # dolphin-emu
    # dolphin-emu-primehack
    # dosbox
    # gamemode
    # gamepad-tool
    # gamescope
    # glibc  
    # glxinfo
    # heroic
    # libglvnd  
    # libva-utils
    # libvdpau-va-gl
    # lutris
    # mangohud
    # mesa
    # mesa-demos
    # openssl_1_1
    # protonup-qt  # Run Proton afterwards in terminal to install latest version
    # protontricks
    # steam
    # steam-run
    # steamtinkerlaunch  # Afterwards run: steamtinkerlaunch compat add
    # suyu
    # vaapiVdpau
    # vkbasalt  # Vulkan post-processing layer for improved visuals
    # xdg-desktop-portal
    # xdg-desktop-portal-gtk
  ];


}

