let

  inherit (import ./variables.nix) BT-status;
in
{
  services.blueman.enable = BT-status;

  hardware.bluetooth = {
    enable = BT-status;
    powerOnBoot = BT-status;
  };
}
