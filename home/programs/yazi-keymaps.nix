{
  programs.yazi.settings = {
    keymap = {
      manager.prepend_keymap = [
        {
          on = ["Return"];
          run = "plugin --sync smart-enter";
          desc = "Enter the child directory, or open the file";
        }
      ];

      opener = {
        archive = [
          {
            run = ''extracto \"$1\" 2>&1'';
            block = true;
            desc = "Extract using custom script";
            display_name = "Extract archives";
          }
        ];

        text = [
          {
            run = ''$EDITOR "$@"'';
            orphan = true;
          }
        ];
        image = [
          {
            run = ''imv "$@"'';
            orphan = true;
            display_name = "Open";
          }
          {
            run = ''exiftool "$1"; echo "Press enter to exit"; read'';
            block = true;
            display_name = "Show EXIF";
          }
        ];
        pdf = [
          {
            run = ''zathura "$@"'';
            orphan = true;
            display_name = "Open";
          }
        ];
        video = [
          {
            run = ''mpv "$@"'';
            orphan = true;
          }
          {
            run = ''mediainfo "$1"; echo "Press enter to exit"; read'';
            block = true;
            display_name = "Show media info";
          }
        ];
        audio = [
          {
            run = ''xdg-open "$@"'';
            orphan = true;
          }
          {
            run = ''mediainfo "$1"; echo "Press enter to exit"; read'';
            block = true;
            display_name = "Show media info";
          }
        ];
        fallback = [
          {
            run = ''xdg-open "$@"'';
            orphan = true;
            display_name = "Open";
          }
        ];
      };

      # ... rest of your keymap configuration
    };
  };
}
