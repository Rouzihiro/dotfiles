{
  inputs,
  pkgs,
  ...
}: {
  terminal = {
    tmux.enable = true;
    foot.enable = true;
    alacritty.enable = false;
    kitty.enable = false;
  };

  shell = {
    zsh.enable = false;
    fish.enable = false;
  };

  editor.neovim.enable = true;

  fileManager = {
    vifm.enable = true;
    ranger.enable = false;
    yazi.enable = false;
    lf.enable = false;
  };

  browser = {
    librewolf.enable = true;
    brave.enable = false;
    qutebrowser.enable = false;
    firefox.enable = false;
  };

  sysMonitor = {
    btop.enable = true;
    fastfetch.enable = true;
  };

  sysNotifier.dunst.enable = true;

  launcher = {
    wofi.enable = true;
    rofi.enable = true;
  };

  statusBar = {
    waybar.enable = false;
  };

  media = {
    freetube.enable = false;
    mpv.enable = true;
  };

  # music.spicetify.enable = false;

  graphics.gimp.enable = false;

  dev.lazygit.enable = true;

  cli.starship.enable = true;

  docViewer.zathura.enable = true;

  wm = {
    hyprland.enable = false;
    i3.enable = false;
    sway.enable = true;
    qtile.enable = false;
  };

  theme.stylix.enable = true;

  imports = [
    ./system
		./programs
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
