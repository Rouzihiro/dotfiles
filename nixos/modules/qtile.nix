{pkgs, ...}: {
  services.xserver = {
    enable = true;
    xkb = {
      layout = "de";
      options = "caps:escape";
    };
    windowManager.qtile = {
      enable = true;
      extraPackages = python3Packages: with python3Packages; [qtile-extras];
    };
  };
  environment.sessionVariables = {
    XKB_DEFAULT_LAYOUT = "de";
    XKB_DEFAULT_OPTIONS = "caps:escape";
    #WLR_NO_HARDWARE_CURSORS = "1";
    #NIXOS_OZONE_WL = 1;
    #MOZ_ENABLE_WAYLAND = 1;
    #ELECTRON_OZONE_PLATFORM_HINT = 1;
  };

  security = {
    polkit.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal
      pkgs.xdg-desktop-portal-gtk
      #pkgs.xdg-desktop-portal-wlr
    ];
    config.common.default = "*";
  };
  programs.dconf.enable = true;
}
