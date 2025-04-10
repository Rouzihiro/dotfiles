{...}: let
  inherit (import ../../nixos/modules/variables.nix) browser-light imageViewer videoPlayer Editor pdfViewer;
in {
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = "lf";
      # Image MIME types
      "image/png" = "${imageViewer}.desktop";
      "image/jpg" = "${imageViewer}.desktop";
      "image/jpeg" = "${imageViewer}.desktop";
      "image/webp" = "${imageViewer}.desktop";
      "image/gif" = "${imageViewer}.desktop";

      # Web and browser MIME types
      "text/html" = "${browser-light}.desktop";
      "x-scheme-handler/http" = "${browser-light}.desktop";
      "x-scheme-handler/https" = "${browser-light}.desktop";
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

      # PDF MIME type
      "application/pdf" = "${pdfViewer}.desktop";

      # Video MIME types
      "video/mp4" = "${videoPlayer}.desktop";
      "video/mpeg" = "${videoPlayer}.desktop";
      "video/webm" = "${videoPlayer}.desktop";
      "video/avi" = "${videoPlayer}.desktop";
      "video/mkv" = "${videoPlayer}.desktop";
      "video/x-matroska" = "${videoPlayer}.desktop";
      "video/quicktime" = "${videoPlayer}.desktop";
      "video/mp2t" = "${videoPlayer}.desktop";
      "video/ogg" = "${videoPlayer}.desktop";
      "video/x-msvideo" = "${videoPlayer}.desktop";
      "video/x-flv" = "${videoPlayer}.desktop";
      "application/x-flash-video" = "${videoPlayer}.desktop";
      "video/MP2T" = "${videoPlayer}.desktop";
      "image/x-tga" = "${videoPlayer}.desktop";

      # Audio
      "audio/mpeg" = "${videoPlayer}.desktop";
      "audio/x-flac" = "${videoPlayer}.desktop";
      "audio/mp4" = "${videoPlayer}.desktop";
      "application/ogg" = "${videoPlayer}.desktop";
      "audio/x-mod" = "${videoPlayer}.desktop";

      # Text and code MIME types
      "inode/x-empty" = "${Editor}.desktop";
      "text/x-tex" = "${Editor}.desktop";
      "text/x-ruby" = "${Editor}.desktop";
      "text/x-readme" = "${Editor}.desktop";
      "application/x-ruby" = "${Editor}.desktop";
      "text/rhtml" = "${Editor}.desktop";
      "text/plain" = "${Editor}.desktop";
      "text/markdown" = "${Editor}.desktop";
      "text/x-shellscript" = "${Editor}.desktop";
      "application/x-sh" = "${Editor}.desktop";
      "application/xml" = "${Editor}.desktop";
      "text/x-nix" = "${Editor}.desktop";
      "text/x-python" = "${Editor}.desktop";
      "text/x-c" = "${Editor}.desktop";
      "text/x-java" = "${Editor}.desktop";
      "text/x-markdown" = "${Editor}.desktop";
      "text/css" = "${Editor}.desktop";
      "text/csv" = "${Editor}.desktop";
      "text/javascript" = "${Editor}.desktop";
      "application/json" = "${Editor}.desktop";
    };
  };
}
