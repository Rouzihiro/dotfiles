{config, ...}: {
  programs.swaylock = {
    enable = true;
    settings = {
      image = "${config.home.homeDirectory}/home/rey/Pictures/lockscreen/VIM.png";
      scaling = "fill"; 
      #color = "000000"; 
      ignore-empty-password = true;
      show-failed-attempts = true; 
    };
  };
}
