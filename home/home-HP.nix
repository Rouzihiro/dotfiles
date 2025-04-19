{
  inputs,
  pkgs,
  ...
}: {

	editor.neovim.enable = true;
  fileManager.vifm.enable = true;
 	fileManager.ranger.enable = false;
	fileManager.yazi.enable = false;
	fileManager.lf.enable = false;
	browser.librewolf.enable = true;
	browser.brave.enable = false;
	browser.qutebrowser.enable = false;
	browser.firefox.enable = false;
	terminal.tmux.enable = true;
	terminal.foot.enable = true;
	terminal.alacritty.enable = false;
	terminal.kitty.enable = false;
	shell.zsh.enable = false;
	shell.fish.enable = false;
	sysMonitor.btop.enable = true;
	sysMonitor.fastfetch.enable = true;
	sysNotifier.dunst.enable = true;
	media.freetube.enable = false;
	media.mpv.enable = true;
	#music.spicetify.enable = false;
	graphics.gimp.enable = false;
	dev.lazygit.enable = true;
	cli.starship.enable = true;
	docViewer.zathura.enable = true;
	wm.hyprland.enable = false;
	wm.i3.enable = false;
	wm.sway.enable = true;
	wm.qtile.enable = false;

  imports = [
    #./system/anyrun.nix
    ./system/dunst.nix
    ./system/hyprland-uwsm.nix
    ./system/mime.nix
    ./system/rofi
    ./system/qtile
    ./system/i3.nix
    ./system/stylix.nix
    ./system/sway.nix
    #./system/waybar.nix
    ./system/wofi.nix
    ./system/wlsunset.nix
    # ./system/xdg.nix
    #./programs/x11.nix

    ./programs
  	./programs/bash
    ./programs/lf
    ./programs/nvim
    ./programs/vifm

    ./scripts-nix
  ];

  home.packages = [
    inputs.yt-x.packages.${pkgs.system}.default
    #inputs.infinity-glass.packages.${pkgs.system}.default
  ];

  home.file = {
    "Pictures/wallpapers" = {
      source = "${inputs.assets.packages.x86_64-linux.assets}/wallpapers";
      recursive = true;
    };
    "Pictures/wallpapers-live" = {
      source = "${inputs.assets.packages.x86_64-linux.assets}/wallpapers-live";
      recursive = true;
    };
    "Pictures/avatars" = {
      source = "${inputs.assets.packages.x86_64-linux.assets}/avatars";
      recursive = true;
    };
    "Pictures/lockscreen" = {
      source = "${inputs.assets.packages.x86_64-linux.assets}/lockscreen";
      recursive = true;
    };
    "Pictures/icons" = {
      source = "${inputs.assets.packages.x86_64-linux.assets}/icons";
      recursive = true;
    };
  };
}
