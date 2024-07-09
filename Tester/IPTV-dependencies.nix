{ pkgs, lib, config, ... }:
{

environment.systemPackages = with pkgs; [
    dmenu
    mpv
    gnused
    coreutils
  ];
}

#https://iptv-org.github.io/