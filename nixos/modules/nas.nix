{
  fileSystems."/home/rey/mount/nas" = {
    device = "//192.168.178.1/FRITZ.NAS";
    fsType = "cifs";
    options = [
      "credentials=/home/rey/secrets/nas-credentials"
      "vers=2.1"
      "nounix"
      "rw"
      "uid=1000"
      "gid=100"
      "file_mode=0770"
      "dir_mode=0770"
      "nofail"
      "noauto"
      "x-systemd.automount"
      "x-systemd.requires=network-online.target"
      "x-systemd.after=network-online.target"
      #"x-systemd.idle-timeout=30"
    ];
  };
}
