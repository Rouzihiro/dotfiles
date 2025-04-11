{
  pkgs,
  ...
}: {
  services.picom = {
    enable = true;
    backend = "glx";
    fade = true;
    shadow = true;
    settings = {
			vsync = true; # Or false if experiencing tearing
			use-damage = true; # Improves performance
      blur = {
        method = "dual_kawase";
        strength = 8;
      };
    };
  };

  services.xserver = {
    enable = true;
    xkb.layout = "de";

    desktopManager = {
      xterm.enable = false;
    };

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu
        i3status
        i3lock
        i3blocks
      ];
    };
  };
}
