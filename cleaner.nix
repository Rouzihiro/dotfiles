{ config, pkgs, ... }:

{
 
 
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = ["nix-command"];
      warn-dirty = false;
      trusted-users = ["root" "@wheel"];
      log-lines = 30;
      http-connections = 50;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    optimise = {
      automatic = true;
      dates = ["weekly"];
    };
  };
  }
