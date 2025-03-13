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

  environment.variables = {
    FREETYPE_PROPERTIES = "cff:no-stem-darkening=0 autofitter:no-stem-darkening=0";
    EDITOR = "nvim";
    VISUAL = "nvim";
    TERMINAL = "foot";
    TERM = "foot";
  };
}
