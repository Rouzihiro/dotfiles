{ config, pkgs, lib, ... }:

{
  # Erlauben unfreie Pakete für Steam
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam"
    "steam-original"
    "steam-run"
  ];

  # Definition des Benutzers rey-multimedia
  users.users."rey-multimedia" = {
    isNormalUser = true;
    home = "/home/rey-multimedia";
    description = "Rey Multimedia - Multimedia and Gaming User";
    extraGroups = [
      "networkmanager" "wheel" "kvm" "input" "disk" 
      "libvirtd" "gamemode" "render" "games" 
      "storage" "flatpak" "qemu"
    ];

    packages = with pkgs; [
      # Pakete für Multimedia und Gaming
      #steam                  # Steam für Spiele
      #mesa                   # Open-Source-Implementierung der OpenGL-Spezifikation
      #libglvnd               # GL Vendor-Neutral Dispatch-Bibliothek
      #libGL                  # Core OpenGL-Bibliothek
      cemu                   # Cemu (Wii U Emulator)
      mpv                    # mpv Medienplayer
      dolphin-emu            # Dolphin Emulator
      dolphin-emu-primehack  # Dolphin Emulator mit Primehack
      wine
      wineWowPackages.stable
      winetricks
      lutris
      heroic
      maim       # Screenshot-Tool
      xdotool    # Automatisierungs-Tool
      cifs-utils  # netwrk sharing
      samba     # netwrk sharing
    ];

  };
}
