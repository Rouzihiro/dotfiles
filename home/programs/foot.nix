{ lib, ... }:
{
  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
			  colors = {
      		background = "000000";  # Black background
      		foreground = "ffffff";  # White text
      		alpha = lib.mkForce "0.8";
				};
			  main = {
      		pad = "20x20";
				};
      mouse = { hide-when-typing = "yes"; };
      tweak = { font-monospace-warn = "no"; };
      };
  };
}
