{
  env = [
    "XDG_SESSION_TYPE                    ,  wayland  "
    "XDG_CURRENT_DESKTOP                 ,  Hyprland "
    "XDG_SESSION_DESKTOP                 ,  Hyprland "

    "DISABLE_QT5_COMPAT                  , 1         "
    "QT_AUTO_SCREEN_SCALE_FACTOR         , 1         "
    "QT_WAYLAND_DISABLE_WINDOWDECORATION , 1         "

    "MOZ_ENABLE_WAYLAND                  , 1         "
    "NIXOS_OZONE_WL                      , 1         "
    "ELECTRON_OZONE_PLATFORM_HINT        , auto      "

    "GTK_WAYLAND_DISABLE_WINDOWDECORATION, 1         "

    "NIXOS_XDG_OPEN_USE_PORTAL , 1"
    "NIXPKGS_ALLOW_UNFREE, 1"
    "GDK_BACKEND, wayland, x11"
    "CLUTTER_BACKEND, wayland"
    "QT_QPA_PLATFORM=wayland;xcb"
    "SDL_VIDEODRIVER, x11"
  ];
}
