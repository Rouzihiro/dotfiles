{
  # Remove CUDA support since you have an Intel GPU
  services.ollama = {
    enable = true;
    acceleration = null;
  };

  services.open-webui = {
    enable = true;
    host = "0.0.0.0";
    openFirewall = true;
  };
}

