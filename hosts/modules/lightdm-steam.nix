{ ... }: 
{
    services.xserver.displayManager.lightdm.enable = true;
    services.xserver.enable = true;
    programs.steam.gamescopeSession.enable = true;
    programs.gamescope.enable = true;
}
