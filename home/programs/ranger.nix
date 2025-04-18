{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  name = "ranger";
  category = "fileManager";
  cfg = config.${category}.${name};
in {
  options.${category}.${name}.enable = mkEnableOption "Enable ${name}";

  config = mkIf cfg.enable {
    programs.${name} = {
      enable = true;
    mappings = {
      e = "edit";
      ec = "compress";
      ex = "extract";

      gd = "cd ~/Downloads";
      gv = "cd ~/Videos";
      gx = "cd ~/Pictures";
      gg = "cd ~/Games";
      gf = "cd ~/dotfiles";
      gs = "cd ~/dotfiles/home/scripts";
      gp = "cd ~/dotfiles/home/programs";
      gu = "cd ~/mount/usb";
    };

    settings = {
      preview_images = true;
      preview_images_method = "ueberzug";
      draw_borders = true;
      w3m_delay = 0;
    };

    extraConfig = ''
      default_linemode devicons2
    '';

    plugins = [
      {
        name = "ranger-archives";
        src = builtins.fetchGit {
          url = "https://github.com/maximtrp/ranger-archives";
          ref = "master";
          rev = "b4e136b24fdca7670e0c6105fb496e5df356ef25";
        };
      }
      {
        name = "ranger-devicons2";
        src = builtins.fetchGit {
          url = "https://github.com/cdump/ranger-devicons2";
          ref = "master";
          rev = "94bdcc19218681debb252475fd9d11cfd274d9b1";
        };
      }
      {
        name = "ranger_tmux";
        src = builtins.fetchGit {
          url = "https://github.com/joouha/ranger_tmux";
          ref = "master";
          rev = "05ba5ddf2ce5659a90aa0ada70eb1078470d972a";
        };
      }
    ];
  };

  #home.file.".config/ranger/commands.py".text = "from plugins.ranger_udisk_menu.mounter import mount";

  programs.fish.interactiveShellInit = ''
    function ranger-cd
      set tempfile (mktemp -t tmp.XXXXXX)
      ranger --choosedir="$tempfile" --cmd="chain zz $argv"

      if test -f "$tempfile"
        set newdir (cat "$tempfile")
        if test "$newdir" != (pwd)
          zoxide add "$newdir"
          cd "$newdir"
        end
        rm -f "$tempfile"
      end
      commandline -f repaint
    end

    bind \cr 'ranger-cd; commandline -f repaint'
    bind \er 'ranger-cd (pwd); commandline -f repaint'
  '';
};
}
