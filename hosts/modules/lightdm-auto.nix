{ ... }:
{
    services.xserver.displayManager.autoLogin.enable = true;
    services.xserver.displayManager.autoLogin.user = "rey";
    systemd.services."getty@tty1".enable = false;
    systemd.services."autovt@tty1".enable = false;
}
