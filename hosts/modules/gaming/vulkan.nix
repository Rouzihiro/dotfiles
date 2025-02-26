{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Vulkan drivers and tools
    vulkan-loader # For INTEL GPUs
    vulkan-validation-layers # For INTEL GPUs 
    vulkan-tools

    # GPU-specific Vulkan drivers
    # amdvlk  # For AMD GPUs
    # nvidiaVulkan  # For NVIDIA GPUs

    # Steam
    # steam
    # steam-run
  ];

  # If you're using NVIDIA GPU, you might also need to enable the NVIDIA drivers
  # services.xserver.videoDrivers = [ "nvidia" ];  # For NVIDIA GPUs
}
