{ config, lib,  ... }:
let
  inherit (lib) mkEnableOption mkIf;
  name = "zathura";
  category = "docViewer";
  cfg = config.${category}.${name};
in {
  options.${category}.${name}.enable = mkEnableOption "Enable ${name}";

  config = mkIf cfg.enable {
    programs.${name} = {
    enable = true;

    options = {
      guioptions = "g";
      adjust-open = "width";
      statusbar-basename = true;
      render-loading = false;
      scroll-step = 120;
    };

    extraConfig = ''
      map b navigate previous
      map f navigate next
    '';
  };
};
}
