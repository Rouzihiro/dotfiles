{
  networking.firewall.allowedTCPPorts = [ 22 ];

  services.openssh = {
    enable = true;
    ports = [ 22 ];

    settings = {
      PasswordAuthentication = true;
      UseDns = true;
    };
  };
}
