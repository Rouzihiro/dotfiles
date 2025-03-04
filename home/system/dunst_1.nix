{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        frame_color = "#cba6f7c0";
        separator_color = "frame";
        highlight = "#89b4fac0";
        frame_width = 2;
        corner_radius = 10;
        origin = "top-right";
        offset = "(54, 18)";
      };
      urgency_low = {
        background = "#1e1e2ec0";
        foreground = "#cdd6f4";
      };
      urgency_normal = {
        background = "#1e1e2ec0";
        foreground = "#cdd6f4";
      };
      urgency_critical = {
        background = "#1e1e2ec0";
        foreground = "#cdd6f4";
        frame_color = "#fab387c0";
      };
    };
  };
}
