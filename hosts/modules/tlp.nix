{
  services.tlp = {
    enable = true;

    settings = {

      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;
      CPU_HWP_DYN_BOOST_ON_AC = 1;
      CPU_HWP_DYN_BOOST_ON_BAT = 0;

      CPU_DRIVER_OPMODE_ON_AC = "active";
      CPU_DRIVER_OPMODE_ON_BAT = "active";

      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";

      PCIE_ASPM_ON_BAT = "powersupersave";
      PCIE_ASPM_ON_AC = "default";

      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "low-power";

      START_CHARGE_THRESH_BAT0 = 40;
      STOP_CHARGE_THRESH_BAT0 = 60;

      NMI_WATCHDOG = 0;

      # Add Intel GPU-specific settings if needed
      # INTEL_GPU_MIN_FREQ_ON_AC = 300;
      # INTEL_GPU_MIN_FREQ_ON_BAT = 100;
      # INTEL_GPU_MAX_FREQ_ON_AC = 1200;
      # INTEL_GPU_MAX_FREQ_ON_BAT = 800;
      # INTEL_GPU_BOOST_FREQ_ON_AC = 1200;
      # INTEL_GPU_BOOST_FREQ_ON_BAT = 800;
    };
  };
}
