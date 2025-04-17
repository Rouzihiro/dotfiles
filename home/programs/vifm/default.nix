{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    tools.vifm.enable = lib.mkEnableOption "Enable vifm";
  };

  config = lib.mkIf config.tools.vifm.enable {
    programs.vifm = {
      enable = true;
    };
    home.file.".config/vifm/scripts/ffprobe.sh".source = ./ffprobe.sh;
    home.file.".config/vifm/colors/mocha.vifm".source = ./mocha.vifm;
    home.file.".config/vifm/colors/starship.vifm".source = ./starship.vifm;
    home.file.".config/vifm/colors/hunter.vifm".source = ./hunter.vifm;
    home.file.".config/vifm/colors/hunterv2.vifm".source = ./hunterv2.vifm;
    home.file.".config/vifm/vifmrc".source = ./vifmrc;

    home.packages = with pkgs; [
      poppler_utils
      sxiv
      ffmpegthumbnailer
      xan
    ];
  };
}
