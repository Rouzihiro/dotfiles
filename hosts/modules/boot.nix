{ lib, ... }:
{
  boot = {
    tmp.cleanOnBoot = true;
    supportedFilesystems.zfs = lib.mkForce false;

    loader = {
      timeout = lib.mkForce 0;
      efi.canTouchEfiVariables = true;

      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };
    };
  };
}
      
