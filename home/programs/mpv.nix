{ config, lib,  ... }:
let
  inherit (lib) mkEnableOption mkIf;
  name = "mpv";
  category = "media";
  cfg = config.${category}.${name};
in {
  options.${category}.${name}.enable = mkEnableOption "Enable ${name}";

  config = mkIf cfg.enable {
    programs.${name} = {
      enable = true;
      config = {
				sub-ass-use-video-data = "aspect-ratio";
        audio-device = "pulse/bluez_output.F8_4D_89_58_BC_65.1";
				hwdec = "auto-safe";
        vo = "gpu";
        profile = "gpu-hq";

        # volume = 100;   # Uncomment if needed
        # hwdec = "auto"; # Uncomment for hardware decoding
      };
      bindings = {
        "Ctrl+f" = "cycle-values video-rotate 0 180";
				"Alt+LEFT" = "add chapter -1";
        "Alt+RIGHT" = "add chapter 1";
      };
    };
  };
}
