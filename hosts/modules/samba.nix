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
        "read only" = "no";
        "browseable" = "yes";
        "valid users" = "rey";
      };
    };
  };

  system.activationScripts.sambaUser = ''
    echo "Adding Samba user 'rey'..."
    export PATH=${pkgs.openssl}/bin:$PATH
    SAMBA_PASSWORD=$(openssl enc -aes-256-cbc -d -pbkdf2 -in /home/rey/secrets/samba_password.enc)
    ${pkgs.samba}/bin/smbpasswd -a -s rey <<EOF
    $SAMBA_PASSWORD
    $SAMBA_PASSWORD
    EOF
  '';

  networking.firewall.allowedTCPPorts = [445 139];
  networking.firewall.allowedUDPPorts = [137 138];
}
