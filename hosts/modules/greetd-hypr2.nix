{ inputs, pkgs, ... }:
let
  variables = import ./variables.nix; 
  theme = variables.currentTheme;    
in
{
  services.greetd.enable = true;

  environment.etc."greetd/tuigreet.css".text = ''
    * {
      font-family: ${theme.fonts.sansSerif.name}, sans-serif;
      font-size: ${toString theme.fonts.sizes.desktop}px;
    }

    window {
      background-color: #${theme.base00};
      color: #${theme.base05};
    }

    #entry {
      background-color: #${theme.base01};
      color: #${theme.base05};
      border: 2px solid #${theme.base0D};
      border-radius: 5px;
    }

    #input {
      background-color: #${theme.base01};
      color: #${theme.base05};
    }

    #text {
      color: #${theme.base05};
    }
  '';

  services.greetd.settings.default_session.command = let
    tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
    cssFile = "/etc/greetd/tuigreet.css";
  in "${tuigreet} --remember --asterisks --container-padding 2 --no-xsession-wrapper --css ${cssFile} --cmd Hyprland";

  systemd = {
    extraConfig = "DefaultTimeoutStopSec=10s";
    services.greetd.serviceConfig = {
      Type = "idle";
      StandardInput = "tty";
      StandardOutput = "tty";
      StandardError = "journal";
      TTYReset = true;
      TTYVHangup = true;
      TTYVTDisallocate = true;
    };
  };
}
