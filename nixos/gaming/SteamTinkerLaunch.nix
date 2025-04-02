{ config, pkgs, lib, ... }:
{
  # game related apps
  environment.systemPackages = with pkgs; [
    unzip
    wget
    xdotool
    xxd
    pkgs.xorg.xwininfo
    yad
      ];
  }

