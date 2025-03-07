{
  hostname,
  inputs,
  pkgs,
  lib,
  ...
}: let
  loadModule = file: {condition ? true}: {
    inherit file condition;
  };

  systemModules = [
    #(loadModule ./system/xdg.nix {})
    (loadModule ./system/mime.nix {})
    (loadModule ./system/dunst.nix {})
    (loadModule ./system/stylix.nix {})
    (loadModule ./system/wlsunset.nix {})
    (loadModule ./system/wofi.nix {})
    (loadModule ./scripts-nix {})
  ];

  programModules = [
    (loadModule ./programs/fish.nix {})
    (loadModule ./programs/shell.nix {})
    (loadModule ./programs/foot.nix {})
    (loadModule ./programs/tmux.nix {})
    (loadModule ./programs/nixvim.nix {})
    (loadModule ./programs/yazi.nix {})
    (loadModule ./programs/lf {})
    (loadModule ./programs/fzf-preview.nix {})
    (loadModule ./programs/git.nix {})
    (loadModule ./programs/packages.nix {})
    (loadModule ./programs/packages2.nix {})
    (loadModule ./programs/zathura.nix {})
    (loadModule ./programs/btop.nix {})
    (loadModule ./programs/fastfetch.nix {})
    (loadModule ./programs/qutebrowser.nix {})
    (loadModule ./programs/brave.nix {})
  ];

  # DE-Modules: Select hosts for each DE individually
  deModules = [
    (loadModule ./system/i3.nix {condition = lib.elem hostname ["Server"];})
    (loadModule ./system/sway.nix {condition = lib.elem hostname ["HP" "MBPro"];})
    (loadModule ./system/hyprland-uwsm.nix {condition = lib.elem hostname ["XX"];})
    (loadModule ./system/fnott.nix {condition = lib.elem hostname ["XX"];})
    (loadModule ./system/anyrun.nix {condition = lib.elem hostname ["HP" "MBPro"];})
    (loadModule ./programs/kitty.nix {condition = lib.elem hostname ["XX"];})
  ];

  barModules = [
    (loadModule ./system/waybar.nix {condition = lib.elem hostname ["XX"];})
  ];

  # Miscellaneous Modules (Games, Extra Apps, Custom Picks)
  miscModules = [
    (loadModule ./programs/gaming.nix {condition = lib.elem hostname ["HP"];})
    (loadModule ./programs/spicetify.nix {condition = lib.elem hostname ["XX"];})
    (loadModule ./programs/starship.nix {condition = lib.elem hostname ["XX"];})
    (loadModule ./programs/zsh.nix {condition = lib.elem hostname ["XX"];})
    (loadModule ./programs/freetube.nix {condition = lib.elem hostname ["XX"];})
    (loadModule ./programs/firefox.nix {condition = lib.elem hostname ["XX"];})
  ];

  # Filter modules based on their condition
  allModules = systemModules ++ programModules ++ deModules ++ miscModules ++ barModules;
  enabledModules = map (x: x.file) (lib.filter (x: x.condition) allModules);
in {
  imports = enabledModules;

  home.packages = with pkgs; [
    inputs.yt-x.packages.${pkgs.system}.default
    inputs.infinity-glass.packages."${pkgs.system}".default
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
