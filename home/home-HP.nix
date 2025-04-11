{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    #./system/anyrun.nix
    ./system/dunst.nix
    #./system/hyprland-uwsm.nix
    ./system/mime.nix
    ./system/rofi
		#./system/qtile
		./system/i3.nix
    ./system/stylix.nix
    ./system/sway.nix
    ./system/waybar.nix
    ./system/wofi.nix
    ./system/wlsunset.nix
    # ./system/xdg.nix
		#./programs/x11.nix

		./programs/alacritty.nix
    ./programs/btop.nix
    ./programs/brave.nix
		./programs/direnv.nix
    ./programs/fastfetch.nix
    #./programs/firefox.nix
    ./programs/fish.nix
    ./programs/foot.nix
    #./programs/freetube.nix
    ./programs/fzf-preview.nix
    ./programs/git.nix
    #./programs/kitty.nix
    ./programs/lf
    ./programs/mpv.nix
    ./programs/nvim
    ./programs/packages.nix
    ./programs/packages2.nix
    ./programs/qutebrowser.nix
    #./programs/ranger.nix
    ./programs/shell.nix
    #./programs/spicetify.nix
    #./programs/starship.nix
    ./programs/tmux.nix
    #./programs/yazi.nix
    ./programs/zathura.nix
    #./programs/zsh.nix

    ./scripts-nix
  ];

  home.packages = [
    inputs.yt-x.packages.${pkgs.system}.default
    inputs.infinity-glass.packages.${pkgs.system}.default
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
