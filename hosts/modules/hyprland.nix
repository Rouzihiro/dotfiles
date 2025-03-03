{pkgs, ...}: {
  programs.hyprland = {
    enable = true;
    # withUWSM = true;
    xwayland.enable = true;
  };

  systemd.user.services.hyprpolkitagent = {
    description = "Hyprpolkitagent - Polkit authentication agent";
    wantedBy = ["graphical-session.target"];
    wants = ["graphical-session.target"];
    after = ["graphical-session.target"];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  security = {
    polkit.enable = true;
    #sudo.wheelNeedsPassword = false;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [xdg-desktop-portal-gtk];
  };

  # Enable dconf for home-manager
  programs.dconf.enable = true;

  #test later systemd.user.targets.hyprland-session.Unit.Wants = [ "xdg-desktop-autostart.target" ];
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    plugins = [
      # inputs.hyprland-plugins.packages.${pkgs.system}.hyprwinwrap
    ];
    systemd = {
      enable = true;
      variables = ["--all"];
    };
  };
}
