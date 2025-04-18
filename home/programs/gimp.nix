{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  name = "gimp";
  category = "graphics";
  cfg = config.${category}.${name};
in {
  options.${category}.${name}.enable = mkEnableOption "Enable ${name}";

  config = mkIf cfg.enable {
    home.packages = [ pkgs.${name} ];
    
    xdg.configFile."GIMP/2.10/themerc".text = ''
      style "gimp-spin-scale-style" {
        GimpSpinScale::compact = 1
      }
      class "GimpSpinScale" style "gimp-spin-scale-style"

      # Dynamic paths using the GIMP package
      include "${pkgs.${name}}/share/gimp/2.0/themes/System/gtkrc"
      include "${pkgs.${name}}/etc/gimp/2.0/gtkrc"
    '';
  };
}
