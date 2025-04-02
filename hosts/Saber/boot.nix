{pkgs, lib, ...}: {

	boot.efi.partition = "/dev/sda1";
  boot = {
    tmp.cleanOnBoot = true;
		supportedFilesystems.zfs = lib.mkForce false;
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };
    };
    # Set xanmod kernel
    kernelPackages = pkgs.linuxPackages_xanmod_latest;
  };
}
