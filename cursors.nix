{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    capitaine-cursors
  ];

  # Set cursor theme for X11
  environment.variables = {
    XCURSOR_THEME = "capitaine-cursors";
    XCURSOR_SIZE = "24";
  };

  # Set the cursor theme for GTK applications
  environment.etc."gtk-3.0/settings.ini".text = ''
    [Settings]
    gtk-cursor-theme-name = capitaine-cursors
    gtk-cursor-theme-size = 24
  '';

  # Set the cursor theme for GTK2 applications
  environment.etc."gtk-2.0/settings.ini".text = ''
    gtk-cursor-theme-name = capitaine-cursors
    gtk-cursor-theme-size = 24
  '';
}

