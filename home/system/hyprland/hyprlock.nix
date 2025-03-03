{
  programs.hyprlock = {
    enable = true;

    settings = {
      general = {
        grace = 60;
        no_fade_in = true;
        no_fade_out = true;
        disable_loading_bar = false;
      };

      input-field = {
        size = "100%, 100%";
        outline_thickness = 3;

        fade_on_empty = false;
        rounding = 15;

        position = "0, -40";
        halign = "center";
        valign = "center";
      };
    };
  };
}
