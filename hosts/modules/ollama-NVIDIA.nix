{
  nixpkgs.config.cudaSupport = true;

  services.ollama = {
    enable = true;
    acceleration = "cuda";
  };

  services.open-webui = {
    enable = true;
    host = "0.0.0.0";
    openFirewall = true;
  };
}
