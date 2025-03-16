{...}: {
  programs.mpv = {
    enable = true;
    config = {
      #sub-ass-vsfilter-aspect-compat = "no";
      #audio-device = "pulse/bluez_output.F8_4D_89_58_BC_65.1";
      #volume = 100; # Default volume
      #hwdec = "auto"; # Enable hardware decoding
    };
    bindings = {
      "Ctrl+f" = "cycle-values video-rotate 0 180";
    };
  };
}
