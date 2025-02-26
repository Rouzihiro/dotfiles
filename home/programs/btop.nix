{
  programs.btop = {
    enable = true;
    settings = {
      update_ms = 1000;
      rounded_corners = false;
      proc_sorting = "memory";
      shown_boxes = "proc cpu ";
    };
  };
}
