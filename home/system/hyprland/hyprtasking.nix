{
  wayland.windowManager.hyprland.extraConfig = ''
    plugin {
      hyprtasking {
        layout = grid

        gap_size = 15
        bg_color = 0x11111b
        border_size = 4
        exit_behavior = active interacted original hovered

        gestures {
          enabled = true
          open_fingers = 3
          open_distance = 300
          open_positive = true
        }

        grid {
          rows = 3
          cols = 3
        }

        linear {
          height = 400
          scroll_speed = 1.1
          blur = 0
        }
      }
    }
  '';
}
