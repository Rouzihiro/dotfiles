{ BT-status, ... }: {
  services.blueman.enable = BT-status;

  hardware.bluetooth = {
    enable = BT-status;
    powerOnBoot = BT-status;
  };
}
