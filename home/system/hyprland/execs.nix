{
  wayland.windowManager.hyprland.settings = {
    exec-once = [
      "sleep 1 && waybar"
      "rm '$XDG_CACHE_HOME/cliphist/db'" # Clear clipboard
      "polkit-agent-helper-1"
    ];
  };
}
