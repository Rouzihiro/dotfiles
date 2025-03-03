{
  wayland.windowManager.hyprland.extraConfig = ''
    general {
      gaps_in = 4
      gaps_out = 9
      border_size = 2
      col.active_border = rgba(ca9ee6ff) rgba(f2d5cfff) 45deg
      col.inactive_border = rgba(b4befecc) rgba(6c7086cc) 45deg

      layout = dwindle
      resize_on_border = true
    }
    group {
        col.border_active = rgba(ca9ee6ff) rgba(f2d5cfff) 45deg
        col.border_inactive = rgba(b4befecc) rgba(6c7086cc) 45deg
        col.border_locked_active = rgba(ca9ee6ff) rgba(f2d5cfff) 45deg
        col.border_locked_inactive = rgba(b4befecc) rgba(6c7086cc) 45deg
    }

    decoration {
        rounding = 10
        shadow:enabled = false

        blur {
            enabled = yes
            size = 6
            passes = 3
          # vibrancy = 0.5
            new_optimizations = true
            ignore_opacity = true
            xray = false
        }
    }

    layerrule = blur,waybar

    decoration {
        dim_special = 0.3
        blur {
          special = true
        }
    }
  '';
}
