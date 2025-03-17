{ pkgs, ...}: {
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
    xserver.enable = false;
    gvfs.enable = false;
    #tumbler.enable = true; # Thumbnail support for images
    #dbus.enable = true;
    #udisks2.enable = true;
  };

  programs.dconf.enable = true;

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

  environment.systemPackages = with pkgs; [
    udiskie
  ];


  environment.variables = {
    FREETYPE_PROPERTIES = "cff:no-stem-darkening=0 autofitter:no-stem-darkening=0";
    EDITOR = "nvim";
    VISUAL = "nvim";
    TERMINAL = "foot";
    TERM = "foot";
  };
}
