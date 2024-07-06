{config, pkgs, ...}:
{
services.greetd = {
  enable = true;
  settings = rec {
    initial_session = {
      command = "${pkgs.sway}/bin/sway";
      user = "rey";
    };
    default_session = initial_session;
  };
};
}
