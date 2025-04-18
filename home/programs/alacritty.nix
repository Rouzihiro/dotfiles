{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  name = "alacritty";
  cfg = config.terminal.${name};
in {
  options.terminal.${name}.enable = mkEnableOption "Enable ${name}";

  config = mkIf cfg.enable {
    programs.${name} = {
      enable = true;
      settings = {
        window = {
          opacity = lib.mkForce 0.8;
          #decorations = "none";
          padding = {
            x = 5;
            y = 5;
          };
        };
      };
    };
  };
}
