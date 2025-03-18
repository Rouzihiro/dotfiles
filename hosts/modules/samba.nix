{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    samba
    openssl
  ];

  services.samba = {
    enable = true;
    settings = {
      global = {
        security = "user";
      };
      sharedFolder = {
        path = "/home/rey/Downloads/";
        "read only" = "yes";
        "browseable" = "yes";
        "valid users" = "rey";
      };
    };
  };

  networking.firewall.allowedTCPPorts = [445 139];
  networking.firewall.allowedUDPPorts = [137 138];
}


# sudo smbpasswd -a rey
# sudo pdbedit -L
