{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # 64-bit components
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav

    # 32-bit components for Proton compatibility
    pkgsi686Linux.gst_all_1.gstreamer
    pkgsi686Linux.gst_all_1.gst-plugins-base
    pkgsi686Linux.gst_all_1.gst-plugins-good
    pkgsi686Linux.gst_all_1.gst-plugins-bad
    pkgsi686Linux.gst_all_1.gst-plugins-ugly
    pkgsi686Linux.gst_all_1.gst-libav
  ];
}
