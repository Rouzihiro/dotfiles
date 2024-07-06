#vulkan
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
   amdvlk
   # gfxreconstruct
   # glslang
   # spirv-cross
   # spirv-headers
   # spirv-tools
   vulkan-extension-layer
   vulkan-headers
   vulkan-loader
   vulkan-tools
   vulkan-tools-lunarg
   vulkan-utility-libraries
   vulkan-validation-layers
   vkdisplayinfo
   vkd3d
   vkd3d-proton
   vk-bootstrap
  ];
}

