{ pkgs, ... }:
{
  security.polkit.enable = true;

  systemd = {
    user.services.lxqt-policykit-agent = {
      description = "LXQt PolicyKit Authentication Agent";

      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.lxqt-policykit}/libexec/lxqt-policykit-agent";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
}

