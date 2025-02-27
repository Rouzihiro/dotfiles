{
  programs.fastfetch = {
    enable = true;
    settings = {

      "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";

      "logo" = { "padding" = { "top" = 2; }; "type" = "auto"; };

      "display" = { "separator" = " ➜  "; };

      "modules" = [
        {
          "type" = "os";
          "key" = " DISTRO";
          "keyColor" = "31";
        }
        {
          "type" = "kernel";
          "key" = " ├  ";
          "keyColor" = "31";
        }
        {
          "type" = "packages";
          "key" = " ├ 󰏖 ";
          "keyColor" = "31";
        }
        {
          "type" = "shell";
          "key" = " └  ";
          "keyColor" = "31";
        }

        "break"

        {
          "type" = "wm";
          "key" = " DE/WM";
          "keyColor" = "32";
        }
        {
          "type" = "terminal";
          "key" = " ├  ";
          "keyColor" = "32";
        }
        {
          "type" = "wmtheme";
          "key" = " ├ 󰉼 ";
          "keyColor" = "32";
        }
        {
          "type" = "icons";
          "key" = " ├ 󰀻 ";
          "keyColor" = "32";
        }
        {
          "type" = "cursor";
          "key" = " ├  ";
          "keyColor" = "32";
        }
        {
          "type" = "terminalfont";
          "key" = " └  ";
          "keyColor" = "32";
        }

        "break"

        {
          "type" = "host";
          "key" = "󰌢 SYSTEM";
          "keyColor" = "33";
        }
        {
          "type" = "cpu";
          "key" = " ├  ";
          "keyColor" = "33";
        }
        {
          "type" = "gpu";
          "key" = " ├ 󰢮 ";
          "keyColor" = "33";
        }
        {
          "type" = "memory";
          "key" = " ├  ";
          "keyColor" = "33";
        }
        {
          "type" = "swap";
          "key" = " ├  ";
          "keyColor" = "33";
        }
        {
          "type" = "disk";
          "key" = " ├  ";
          "keyColor" = "33";
        }
        {
          "type" = "display";
          "key" = " ├  ";
          "keyColor" = "33";
        }
        {
          "type" = "battery";
          "key" = " └  ";
          "keyColor" = "33";
        }

        "break"

        {
          "type" = "wifi";
          "key" = "󰀂 NETWORK";
          "keyColor" = "34";
        }
        {
          "type" = "localip";
          "key" = " ├ 󰒍 ";
          "keyColor" = "34";
        }
        {
          "type" = "dns";
          "key" = " ├ 󰇖 ";
          "keyColor" = "34";
        }
        {
          "type" = "publicip";
          "key" = " └ 󰩠 ";
          "keyColor" = "34";
        }
      ];
    };
  };
}
