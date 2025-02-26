{ config, pkgs, ... }:

{

services.xserver.displayManager.sddm.enable = true;

#displayManager.sddm = {
#    enable = true;
#    theme = "catppuccin-mocha";
}
