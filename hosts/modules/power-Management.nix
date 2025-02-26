{...}: {
  services.thermald.enable = true; # cooler control (as i understand this)
  services.upower = {
    enable = true;
    percentageCritical = 3;
    criticalPowerAction = "Hibernate";
  };
  powerManagement.powertop.enable = true;
  services.tlp = {
    enable = true;
    settings = {
      USB_AUTOSUSPEND = 0;

      START_CHARGE_THRESH_BAT0 = 30;
      STOP_CHARGE_THRESH_BAT0 = 70;

      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "low-power";

      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 60;

      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;

      CPU_HWP_DYN_BOOST_ON_AC = 1;
      CPU_HWP_DYN_BOOST_ON_BAT = 0;
    };
  };
}