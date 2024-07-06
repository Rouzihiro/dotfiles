{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    bubblewrap
    glib
    dconf
    gvfs
    glib-networking
  ];

  systemd.services.exampleService = {
    description = "An example service using Bubblewrap";
    after = [ "network.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.bubblewrap}/bin/bwrap --bind / / --dev /dev --proc /proc --ro-bind /sys /sys --tmpfs /tmp /path/to/your/application";
      Restart = "always";
      User = "rey"; # Benutzer 'rey' eingetragen
    };
    wantedBy = [ "multi-user.target" ];
  };
}

