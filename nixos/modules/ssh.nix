{pkgs, ...}:
{
  networking.firewall.allowedTCPPorts = [ 22 5900 ];

 services.tailscale.enable = true;
 environment.systemPackages = with pkgs; [ tailscale wayvnc inetutils ];

  services.openssh = {
    enable = true;
    ports = [ 22 5900 ];

    settings = {
      PasswordAuthentication = true;
      UseDns = true;
    };
  };
}
