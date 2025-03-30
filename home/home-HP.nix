{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    # ./system/xdg.nix
    ./system/mime.nix
    ./system/dunst.nix
    ./system/stylix.nix
    ./system/wlsunset.nix
    ./system/wofi.nix
    ./system/rofi
    ./scripts-nix
    ./programs/fish.nix
    ./programs/shell.nix
    ./programs/foot.nix
    ./programs/tmux.nix
    ./programs/nvim
    ./programs/yazi.nix
    ./programs/lf
    # ./programs/ranger.nix
    ./programs/fzf-preview.nix
    ./programs/git.nix
    ./programs/packages.nix
    ./programs/packages2.nix
    ./programs/zathura.nix
    ./programs/btop.nix
    ./programs/fastfetch.nix
    ./programs/qutebrowser.nix
    ./programs/brave.nix
    ./programs/mpv.nix
    ./system/sway.nix
    #./system/hyprland-uwsm.nix
    ./system/anyrun.nix
    #./programs/kitty.nix
    #./system/waybar.nix
    #./programs/spicetify.nix
    #./programs/starship.nix
    #./programs/zsh.nix
    #./programs/freetube.nix
    #./programs/firefox.nix
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
