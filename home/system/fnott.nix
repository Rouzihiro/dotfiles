{ pkgs, ... }:
{
  home.packages = [ pkgs.fyi ];

  services.fnott = {
    enable = true;
    settings = {

      main = {
        border-size = 4;
        min-width = 100;
        max-width = 600;
        max-height = 400;

        # anchor = "center";
        anchor = "top-left";

        background = "1e1e2eff";
        body-color = "bac2deff";
        title-color = "cdd6f4ff";
        border-color = "fab387ff";

        progress-bar-color = "fab387ff";

        body-font = "DroidSansM Nerd Font:size=10";
        title-font = "DroidSansM Nerd Font:size=12";
        title-format = "<b>%a%A\\n<b>";
        summary-format = "%";
      };

      critical = {
        background = "f38ba8ff";
        border-color = "f38ba8ff";
      };
    };
  };
}
