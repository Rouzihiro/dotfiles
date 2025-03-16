{ config, pkgs, lib, ... }:

{
  # Disable PipeWire
  services.pipewire.enable = false;

  # Disable WirePlumber (depends on PipeWire)
  services.pipewire.wireplumber.enable = false;

  # Optionally, revert to PulseAudio if needed
  services.pulseaudio.enable = true;
  services.pulseaudio.support32Bit = true; # If you need 32-bit support
  hardware.pulseaudio.enable = true;

  # Remove PipeWire and WirePlumber packages
  environment.systemPackages = with pkgs; [
    # Add other packages you need here
  ] ++ (lib.optionals (!config.services.pipewire.enable) [
    # Remove PipeWire and WirePlumber packages
    pipewire
    wireplumber
  ]);
}
