{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  name = "btop";
  category = "systemMonitor"; 
  cfg = config.${category}.${name};
in {
  options.${category}.${name}.enable = mkEnableOption "Enable ${name}";

  config = mkIf cfg.enable {
    programs.${name} = {
      enable = true;
      settings = {
        update_ms = 1000;
        rounded_corners = false;
        proc_sorting = "memory";
        shown_boxes = "proc cpu";
        # theme = "catppuccin-mocha";
        vim_keys = true;
      };
    };
  };
}
