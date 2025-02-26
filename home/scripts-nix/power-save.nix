{ pkgs }:

pkgs.writeShellScriptBin "power-save" ''

  ${pkgs.libnotify}/bin/notify-send "Battery Saver" "Battery saver activated"

  # Set CPU energy performance preference to power saving
  echo power | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference > /dev/null

''
