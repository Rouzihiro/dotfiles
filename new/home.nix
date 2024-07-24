{ config, pkgs, ... }:

{
  home.username = "deinBenutzername";
  home.homeDirectory = "/home/deinBenutzername";

  home.stateVersion = "23.05";  # Passe das je nach deiner NixOS-Version an

  # Programme aktivieren
  programs = {
    i3 = {
      enable = true;
      configFile = '' 
        # Füge deine i3-Konfiguration hier ein
        # Beispiel:
        # set $mod Mod4
        # bindsym $mod+Return exec i3-sensible-terminal
      '';
    };

    steam = {
      enable = true;
    };

    # Weitere Programme hier einfügen
  };

  # Programm-spezifische Konfigurationen
  xsession = {
    enable = true;
    windowManager.command = "${pkgs.i3}/bin/i3";
  };

  services.dbus.enable = true;

  # Weitere Konfigurationsdateien und Anpassungen
}