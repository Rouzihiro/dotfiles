{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    cifs-utils  # Required for CIFS filesystem
  ];

  # Configuration for the SMB share
  fileSystems."/mnt/smb" = {
    device = "//192.168.178.1/FRITZ.NAS";
    fsType = "cifs";
    options = [ "credentials=/etc/samba/creds" "rw" "uid=1000" "gid=100" "file_mode=0777" "dir_mode=0777" ];
  };

  # Store credentials for SMB share
  environment.variables = {
    SAMBA_CREDS = "/etc/samba/creds";
  };

  # Auto-mount using gio mount in user session
  systemd.user.services.mount-smb.serviceConfig = {
    description = "Mount SMB share using gio";
    startAt = "graphical.target";
    wantedBy = [ "graphical.target" ];
    serviceConfigType = "simple";
    script = ''
      #!/usr/bin/env sh
      gio mount smb://192.168.178.1/FRITZ.NAS
    '';
  };
}
