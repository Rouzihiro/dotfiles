# waybar.nix

{ config, pkgs, lib, ... }:

{
  options.waybar = {
    enable = true;

    # Example configuration options for Waybar
    config = {
      enableBatteryModule = true;
      enableClockModule = true;
      enableTrayModule = true;
      # Add more configuration options as needed
    };

    # Define additional packages required by Waybar
    extraPackages = with pkgs; [
      waybar
      # Add other necessary packages here
    ];
  };
}

