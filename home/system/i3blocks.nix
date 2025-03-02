{pkgs, ...}: let
  #currentTrack = import ./scripts/currentTrack.nix { inherit pkgs; };
  #dunstNotifToggle = import ./scripts/i3DunstToggle.nix { inherit pkgs; };
  #bluetooth_battery = import ./scripts/bluetooth_battery.nix { inherit pkgs; };
  # using this fork because few scripts have hardcoded shebangs
  # and the user has a patch PR open in the source repo
  #i3blocks-contrib = pkgs.fetchFromGitHub {
  #  owner = "CreativeCactus";
  # repo = "i3blocks-contrib";
  #rev = "b7871d7809b0bcd0ce1c574e4d967d546ebe2f8a";
  #sha256 = "070vpf3nfw4b4cblacr0c5xfs3h6asbbzclcj911skyli3wjrmid";
  # };
in
  pkgs.writeTextFile {
    name = "i3blocksconfig";
    text = ''
      # i3blocks configuration
      separator=false
      markup=pango

      [time]
      command=date '+%a %d %b | %H:%M'
      interval=60
      color=#f5f5f5
      separator=false
      align=center
      label=

      [cpu]
      command=awk -F'[, ]+' '/^Cpu/ {print $2+$4" %"}' <(grep 'cpu ' /proc/stat)
      interval=5
      color=#fcd1d1
      separator=true
      align=center
      label=

      [memory]
      command=free -h | awk '/^Mem:/ {print $3 "/" $2}'
      interval=10
      color=#a6e3a1
      separator=true
      align=center
      label=

      [disk]
      command=df -h / | awk 'NR==2 {print $3 "/" $2}'
      interval=60
      color=#f5a3c7
      separator=true
      align=center
      label=

      [network]
      command=nmcli -t -f active,ssid,signal dev wifi | grep '^yes' | cut -d ':' -f2,3 | awk -F',' '{if ($1) print $1 " (" $2 "%)"; else print "Disconnected"}'
      interval=10
      color=#ebacb7
      separator=true
      align=center
      label=

      [bandwidth]
      command=/home/rey/dotfiles/home/scripts/bandwidth
      interval=1
      color=#a3be8c
      separator=true
      align=center
      label=

      [volume]
      command=wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{if ($3 == "[MUTED]") print "MUTED"; else print int($2 * 100) " %"}'
      interval=1
      color=#f9e2af
      separator=true
      align=center
      label=

      [brightness]
      command=brightnessctl g | awk '{print $1}'
      interval=5
      color=#fab387
      separator=true
      align=center
      label=

      [battery]
      command=cat /sys/class/power_supply/BAT0/capacity | awk '{print $1" %"}'
      interval=30
      color=#74c7ec
      separator=true
      align=center
      label=

      [separator]
      command=echo " "
      interval=1
      color=#1e1e2e
      separator=true
      align=center
    '';
  }
