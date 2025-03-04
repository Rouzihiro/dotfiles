{hostname, ...}: {
  # ---------------------------------------------------------
  # Documentation
  # ---------------------------------------------------------

  documentation = {
    enable = false;
    doc.enable = false;
    man.enable = false;
    dev.enable = false;
    info.enable = false;
    nixos.enable = false;
  };

  # ---------------------------------------------------------
  # System
  # ---------------------------------------------------------

  system = {stateVersion = "25.05";};
  security.pam.services.swaylock = {};

  # Enable sudo and set up no-password configuration for 'rey'
  security.sudo.enable = true;
  security.sudo.extraConfig = ''
    rey ALL=(ALL) NOPASSWD: ALL
  '';

  # ---------------------------------------------------------
  # Systemd
  # ---------------------------------------------------------

  services = {
    chrony.enable = true;
    timesyncd.enable = false;
  };

  services.xserver = {
    xkb = {
      layout = "de";
      variant = "";
    };
  };
  console.keyMap = "de";

  systemd = {
    tpm2.enable = false;
    extraConfig = ''
      DefaultTimeoutStartSec=15s
      DefaultTimeoutStopSec=10s
      DefaultLimitNOFILE=2048
      DefaultLimitNOFILE_HARD=2097152
    '';
  };

  # ---------------------------------------------------------
  # TTY Catppuccin mocha
  # ---------------------------------------------------------

  console.colors = [
    "1e1e2e" # base
    "181825" # mantle
    "313244" # surface0
    "45475a" # surface1
    "585b70" # surface2
    "cdd6f4" # text
    "f5e0dc" # rosewater
    "b4befe" # lavender
    "f38ba8" # red
    "fab387" # peach
    "f9e2af" # yellow
    "a6e3a1" # green
    "94e2d5" # teal
    "89b4fa" # blue
    "cba6f7" # mauve
    "f2cdcd" # flamingo
  ];

  environment.variables = {
    # better fonts:
    # https://web.archive.org/web/20230921201835/https://old.reddit.com/r/linux_gaming/comments/16lwgnj/is_it_possible_to_improve_font_rendering_on_linux/
    FREETYPE_PROPERTIES = "cff:no-stem-darkening=0 autofitter:no-stem-darkening=0";
    EDITOR = "nvim";
    VISUAL = "nvim";
    TERMINAL = "footclient";
    TERM = "footclient";
  };
}
