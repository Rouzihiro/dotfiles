{ pkgs, ... }:
let
  tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
  #hyprland-session = "${pkgs.hyprland}/share/wayland-sessions";
  sway-session = "${pkgs.sway}/share/wayland-sessions";
  i3-session = "${pkgs.i3}/share/xsessions";

in {
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command =
          "${tuigreet} --time --remember --remember-session --sessions ${sway-session}:${i3-session}";
          user = "greeter";
      };
    };
  };

  # this is a life saver.
  # literally no documentation about this anywhere.
  # might be good to write about this...
  # https://www.reddit.com/r/NixOS/comments/u0cdpi/tuigreet_with_xmonad_how/
  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal"; # Without this errors will spam on screen
    # Without these bootlogs will spam on screen
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };
}
