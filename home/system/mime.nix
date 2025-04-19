{
	imageViewer,
	browser,
	pdfViewer,
  videoPlayer,
  ...
}: 

let nvimDesktop = "neovim-terminal.desktop"; in {
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # Image MIME types
      "image/png" = "${imageViewer}.desktop";
      "image/jpg" = "${imageViewer}.desktop";
      "image/jpeg" = "${imageViewer}.desktop";
      "image/webp" = "${imageViewer}.desktop";
      "image/gif" = "${imageViewer}.desktop";

      # Web and browser MIME types
      "text/html" = "${browser}.desktop";
      "x-scheme-handler/http" = "${browser}.desktop";
      "x-scheme-handler/https" = "${browser}.desktop";
      "x-scheme-handler/chrome" = "${browser}.desktop";
      "x-scheme-handler/about" = "${browser}.desktop";
      "x-scheme-handler/unknown" = "${browser}.desktop";
      "default-web-browser" = "${browser}.desktop";
      "application/xhtml+xml" = "${browser}.desktop";
      "application/x-extension-htm" = "${browser}.desktop";
      "application/x-extension-html" = "${browser}.desktop";
      "application/x-extension-shtml" = "${browser}.desktop";
      "application/x-extension-xhtml" = "${browser}.desktop";
      "application/x-extension-xht" = "${browser}.desktop";

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
			"text/plain" = nvimDesktop;
      "text/markdown" = nvimDesktop;
      "text/x-shellscript" = nvimDesktop;
      "text/x-nix" = nvimDesktop;
      "text/x-python" = nvimDesktop;
      "text/x-c" = nvimDesktop;
      "text/x-java" = nvimDesktop;
      "text/x-lua" = nvimDesktop;
      "text/x-tex" = nvimDesktop;
      "text/css" = nvimDesktop;
      "text/csv" = nvimDesktop;
      "text/javascript" = nvimDesktop;
      "application/json" = nvimDesktop;
      "application/xml" = nvimDesktop;
      "inode/x-empty" = nvimDesktop;
      "text/x-ruby" = nvimDesktop;
      "text/x-readme" = nvimDesktop;
      "application/x-ruby" = nvimDesktop;
      "text/rhtml" = nvimDesktop;
      "application/x-sh" = nvimDesktop;
      "text/x-markdown" = nvimDesktop;
    };
  };

	xdg.desktopEntries.neovim-terminal = {
  name = "Neovim (Terminal)";
  genericName = "Text Editor";
  comment = "Edit text files in terminal";
  exec = "foot -e nvim %F";
  terminal = true;
  type = "Application";
  mimeType = [
    "text/plain" "text/markdown" "text/x-shellscript" "text/x-nix"
    "text/x-python" "text/x-c" "text/x-java" "text/x-lua" "text/x-tex"
    "text/css" "text/csv" "text/javascript" "application/json" "application/xml"
  ];
  icon = "neovim";
  categories = ["Utility" "TextEditor"];
};


}
