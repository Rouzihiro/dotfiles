{hostname, ...}: {
  # ---------------------------------------------------------
  # Documentation
  # ---------------------------------------------------------

  # documentation = {
  #   enable = false;
  #   doc.enable = false;
  #   man.enable = false;
  #   man.generateCaches = false;
  #   dev.enable = false;
  #   info.enable = false;
  #   nixos.enable = false;
  # };

  # ---------------------------------------------------------
  # System
  # ---------------------------------------------------------

  # Enable sudo and set up no-password configuration for 'rey'
  security.sudo.enable = true;
  security.sudo.extraConfig = ''
    rey ALL=(ALL) NOPASSWD: ALL
  '';

  environment.variables = {
    FREETYPE_PROPERTIES = "cff:no-stem-darkening=0 autofitter:no-stem-darkening=0";
    EDITOR = "nvim";
    VISUAL = "nvim";
    TERMINAL = "foot";
    TERM = "foot";
  };

  system = {stateVersion = "25.05";};
  security.pam.services.swaylock = {};

  hardware = {
    enableAllFirmware = true;
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  services.xserver = {
    xkb = {
      layout = "de";
      variant = "";
    };
  };

  console.keyMap = "de";

  # services = {
  #   chrony.enable = true;
  #   logrotate.enable = false;
  #   timesyncd.enable = false;
  #   logind = { lidSwitch = "ignore"; lidSwitchExternalPower = if hostname == "server" then "ignore" else "suspend-then-hibernate"; };
  # };

  # systemd = {
  #   tpm2.enable = true;
  #   services.systemd-journald.enable = true;
  #   services.systemd-journal-flush.enable = true;
  #   services.systemd-journal-catalog-update.enable = true;
  #   extraConfig = ''
  #     DefaultTimeoutStartSec=15s
  #     DefaultTimeoutStopSec=10s
  #     DefaultLimitNOFILE=2048
  #     DefaultLimitNOFILE_HARD=2097152
  #   '';
  #
  # };
}
