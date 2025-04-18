{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  name = "freetube";
  category = "media";
  cfg = config.${category}.${name};
in {
  options.${category}.${name}.enable = mkEnableOption "Enable ${name}";

  config = mkIf cfg.enable {
    programs.${name} = {
    enable = true;

    settings = {
      allowDashAv1Formats = true;
      defaultQuality = "1080";
      useSponsorBlock = true;

      backendFallback = true;

      autoplayPlaylists = false;
      autoplayVideos = false;
      expandSideBar = false;
      hideLabelsSideBar = true;

      checkForBlogPosts = false;
      checkForUpdates = false;

      mainColor = "CatppuccinMochaMauve";
      secColor = "CatppuccinMochaPink";
      baseTheme = "catppuccinMocha";
      barColor = false;
    };
  };
};
}
