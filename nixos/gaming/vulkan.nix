{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vulkan-loader # For INTEL GPUs
    vulkan-validation-layers # For INTEL GPUs 
    vulkan-tools

    # GPU-specific Vulkan drivers
    # amdvlk  # For AMD GPUs
    # nvidiaVulkan  # For NVIDIA GPUs
  ];
}
