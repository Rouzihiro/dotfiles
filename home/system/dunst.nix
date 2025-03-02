{pkgs, ...}: {
  home.packages = with pkgs; [libnotify];

  services.dunst = {
    enable = true;

    settings = {
      global = {
        format = "<b>%s</b>\n%b"; # Bold title and normal body
        alignment = "center"; # Center-align text
        vertical_alignment = "center"; # Center-align vertically
        word_wrap = "yes"; # Enable word wrapping
        line_height = 0; # Automatic line height
        padding = 8; # Padding around text
        horizontal_padding = 8; # Horizontal padding
        separator_height = 2; # Height of the separator line
        frame_width = 2; # Width of the frame

        # Positioning
        follow = "mouse"; # Follow mouse position
        width = "(0, 600)"; # Max width of notifications
        height = "(0, 400)"; # Max height of notifications
        origin = "top-center"; # Position of notifications
        offset = "0x20"; # Offset from the edge of the screen

        # Behavior
        ignore_newline = "no"; # Treat newlines as line breaks
        show_indicators = "yes"; # Show indicators for actions
        stack_duplicates = "yes"; # Stack duplicate notifications
        hide_duplicate_count = "no"; # Show count of duplicate notifications
      };

      # Fullscreen rules
      fullscreen_delay_everything = {
        fullscreen = "delay"; # Delay notifications in fullscreen mode
      };
    };
  };
}
