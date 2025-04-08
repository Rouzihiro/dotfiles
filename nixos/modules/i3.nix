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
        dmenu #application launcher most people use
        i3status # gives you the default i3 status bar
        i3lock #default i3 screen locker
        i3blocks #if you are planning on using i3blocks over i3status
      ];
    };
  };
}
