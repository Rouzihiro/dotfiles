{ hostname, lib, ... }:

let
  # Helper function for conditional module loading
  loadModule = file: { condition ? true }: {
    inherit file condition;
  };

  # Common modules for all hostnames
  commonModules = [
    (loadModule ./modules/boot.nix {})
    (loadModule ./modules/configuration.nix {})
    (loadModule ./modules/nix.nix {})
    (loadModule ./modules/bluetooth.nix {})
    (loadModule ./modules/time.nix {})
    (loadModule ./modules/users.nix {})
    (loadModule ./modules/zram.nix {})
    (loadModule ./modules/network.nix {})
    (loadModule ./modules/nh.nix {})
    (loadModule ./modules/pipewire.nix {})
    (loadModule ./modules/gsettings.nix {})
    (loadModule ./modules/fonts.nix {})
  ];

  # Host-specific modules with conditions
  hostSpecificModules = [
    # HP-specific
    (loadModule ./HP.nix { condition = lib.elem hostname [ "HP" ]; })
    (loadModule ./modules/polkit.nix { condition = lib.elem hostname [ "HP" ]; })
    (loadModule ./modules/sway.nix { condition = lib.elem hostname [ "HP" "MBPro"]; })
    #(loadModule ./modules/qtile.nix { condition = lib.elem hostname [ "HP" ]; })
    #(loadModule ./modules/hyprland-uwsm.nix { condition = lib.elem hostname [ "HP" ]; })
    (loadModule ./modules/android.nix { condition = lib.elem hostname [ "HP" ]; })
    (loadModule ./modules/greetd.nix { condition = lib.elem hostname [ "HP" "MBPro" ]; })
    (loadModule ./modules/tlp.nix { condition = lib.elem hostname [ "HP" ]; })
    (loadModule ./modules/intel.nix { condition = lib.elem hostname [ "HP" "MBPro" ]; })
    (loadModule ./modules/shell-sway.nix { condition = lib.elem hostname [ "HP" "MBPro" ]; })
    (loadModule ./modules/gaming.nix { condition = lib.elem hostname [ "HP" ]; })

    # MBPro-specific
    (loadModule ./MBPro.nix { condition = lib.elem hostname [ "MBPro" ]; })
    
    # Server-specific
    (loadModule ./server.nix { condition = lib.elem hostname [ "server" ]; })
    (loadModule ./modules/nh.nix { condition = lib.elem hostname [ "server" ]; })
    (loadModule ./modules/ssh.nix { condition = lib.elem hostname [ "server" ]; })
    (loadModule ./modules/fstrim.nix { condition = lib.elem hostname [ "server" ]; })

    # Modules for multiple hosts
    (loadModule ./modules/vm.nix { condition = lib.elem hostname [ "XX" ]; })
    (loadModule ./modules/adb.nix { condition = lib.elem hostname [ "XX" ]; })
    (loadModule ./modules/fstrim.nix { condition = lib.elem hostname [ "XX" ]; })
  ];

  # Combine all modules and filter by condition
  allModules = commonModules ++ hostSpecificModules;
  enabledModules = map (m: m.file) (lib.filter (m: m.condition) allModules);

in {
  imports = enabledModules;

  # Add assertion to prevent invalid hostnames
  assertions = [
    {
      assertion = lib.elem hostname [ "HP" "MBPro" "server" "XX" ];
      message = "Invalid hostname '${hostname}'. Valid options: HP, MBPro, server, XX";
    }
  ];
}
