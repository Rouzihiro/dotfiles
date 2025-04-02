{ hostname, ... }:
{
  boot.initrd.systemd.network.wait-online.enable = false;
  systemd.services.NetworkManager-wait-online.enable = false;

  services.resolved.enable = true;

  networking = {
    hostName = "${hostname}";
    firewall.enable = true;

    wireless = {
      enable = false;
      iwd.enable = false;
    };

    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      wifi = {
        powersave = true;
        backend = "wpa_supplicant";
      };
    };
  };
}
