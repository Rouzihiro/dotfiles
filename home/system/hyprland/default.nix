{
  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";
    "$Alt_L" = "ALT";
    "$shiftMod" = "SUPER_SHIFT";
    # App
    "$terminal" = "foot";
    "$browser" = "brave";
    "$browser-light" = "qutebrowser";
    "$launcher" = "anyrun";
    "$file-manager" = "thunar";
    "$Tfile-manager" = "$terminal -e yazi";
    "$audio-manager" = "com.saivert.pwvucontrol";
    "$password-manager" = "org.keepassxc.KeePassXC";
    "$bluetooth-manager" = "io.github.kaii_lb.Overskride";

    #"$scr" = "$HOME/.local/share/bin/";
    #"$term" = "kitty";
    #"$files" = "$term yazi";
    #"$files2" = "nemo";
    #"$edit" = "$term $scr/nv.sh";

    input = {
      kb_layout = "de";
      kb_options = "";
      follow_mouse = "1";
      sensitivity = "0.4";
      #accel_profile = "flat";
      force_no_accel = "1";
      #numlock_by_default = "true";
      touchpad = {
        scroll_factor = 0.5;
        natural_scroll = true;
      };
      dwindle = {
        pseudotile = "yes";
        preserve_split = "yes";
      };
    };

    imports = [
      ./hypridle.nix
      ./hyprlock.nix
      ./binds.nix
      ./env.nix
      ./theme.nix
      ./animations.nix
      ./execs.nix
      ./windowrules.nix
      #./plugins.nix
      #./hyprspace.nix
    ];
  };
}
