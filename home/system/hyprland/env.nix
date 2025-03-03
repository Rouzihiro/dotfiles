{
  wayland.windowManager.hyprland.settings = {
    env = [
      "XDG_CURRENT_DESKTOP,Hyprland"
      "XDG_SESSION_DESKTOP,Hyprland"
      "XDG_SESSION_TYPE,wayland"
      "GDK_BACKEND,wayland,x11,*"
      "NIXOS_OZONE_WL,1"
      "ELECTRON_OZONE_PLATFORM_HINT,auto"
      "MOZ_ENABLE_WAYLAND,1"
      "OZONE_PLATFORM,wayland"
      "EGL_PLATFORM,wayland"
      "CLUTTER_BACKEND,wayland"
      "SDL_VIDEODRIVER,wayland"
      "QT_QPA_PLATFORM,wayland;xcb"
      "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
      "QT_QPA_PLATFORMTHEME,qt6ct"
      "QT_AUTO_SCREEN_SCALE_FACTOR,1"
      "WLR_RENDERER_ALLOW_SOFTWARE,1"
      "NIXPKGS_ALLOW_UNFREE,1"
    ];
  };
}
