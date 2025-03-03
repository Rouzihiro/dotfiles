{...}: let
  inherit (import ../../hosts/modules/variables.nix) browser-light imageViewer videoPlayer Editor pdfViewer;
in {
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "image/png" = "${imageViewer}.desktop";
      "image/jpg" = "${imageViewer}.desktop";
      "image/jpeg" = "${imageViewer}.desktop";
      "image/webp" = "${imageViewer}.desktop";
      "image/gif" = "${imageViewer}.desktop";
      "text/html" = "${browser-light}.desktop";
      "x-scheme-handler/http" = "${browser-light}.desktop";
      "x-scheme-handler/https" = "${browser-light}.desktop";
      "application/pdf" = "${pdfViewer}.desktop";
      "video/mp4" = "${videoPlayer}.desktop";
      "video/mpeg" = "${videoPlayer}.desktop";
      "video/webm" = "${videoPlayer}.desktop";
      "video/avi" = "${videoPlayer}.desktop";
      "video/mkv" = "${videoPlayer}.desktop";
      "video/x-matroska" = "${videoPlayer}.desktop";
      "video/quicktime" = "${videoPlayer}.desktop";
      "text/plain" = "nvim.desktop";
      "text/markdown" = "nvim.desktop";
      "text/x-shellscript" = "${Editor}.desktop";
      "application/x-sh" = "nvim.desktop";
      "application/xml" = "${Editor}.desktop";
      "text/x-nix" = "nvim.desktop";
      "text/x-python" = "${Editor}.desktop";
      "text/x-c" = "${Editor}.desktop";
      "text/x-java" = "${Editor}.desktop";
      "text/x-markdown" = "nvim.desktop";
      "text/css" = "${Editor}.desktop";
      "text/csv" = "${Editor}.desktop";
      "text/javascript" = "${Editor}.desktop";
      "application/json" = "nvim.desktop";
      "x-scheme-handler/chrome" = "${browser-light}.desktop";
      "x-scheme-handler/about" = "${browser-light}.desktop";
      "x-scheme-handler/unknown" = "${browser-light}.desktop";
      "default-web-browser" = "${browser-light}.desktop";
      "application/xhtml+xml" = "${browser-light}.desktop";
      "application/x-extension-htm" = "${browser-light}.desktop";
      "application/x-extension-html" = "${browser-light}.desktop";
      "application/x-extension-shtml" = "${browser-light}.desktop";
      "application/x-extension-xhtml" = "${browser-light}.desktop";
      "application/x-extension-xht" = "${browser-light}.desktop";
    };
  };
}
