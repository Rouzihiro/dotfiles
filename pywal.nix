{ pkgs, lib, config, ... }:
{
environment.systemPackages = with pkgs; [
  pywal
  #pywal-gtk
];
}
