{user, ...}: {
  programs.librewolf = {
    enable = true;
    policies = {
      ExtensionSettings = {
        "*".installation_mode = "blocked";
        # To add additional extensions, find it on addons.mozilla.org, find
        # the short ID in the url (like https://addons.mozilla.org/en-US/firefox/addon/!SHORT_ID!/)
        # Then, download the XPI by filling it in to the install_url template, unzip it,
        # run `jq .browser_specific_settings.gecko.id manifest.json` or
        # `jq .applications.gecko.id manifest.json` to get the UUID
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/en-us/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
          installation_mode = "force_installed";
        };
        "addon@darkreader.org" = {
          install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/darkreader/latest.xpi";
          installation_mode = "force_installed";
        };
        "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
          install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/vimium-ff/latest.xpi";
          installation_mode = "force_installed";
        };
        "jid1-ZAdIEUB7XOzOJw@jetpack" = {
          install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/duckduckgo-for-firefox/latest.xpi";
          installation_mode = "force_installed";
        };
        "jid1-MnnxcxisBPnSXQ@jetpack" = {
          install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/privacy-badger17/latest.xpi";
          installation_mode = "force_installed";
        };
        "{eac6e624-97fa-4f28-9d24-c06c9b8aa713}" = {
          install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/material-icons-for-github/latest.xpi";
          installation_mode = "force_installed";
        };
        "@testpilot-containers" = {
          install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/multi-account-containers/latest.xpi";
          installation_mode = "force_installed";
        };
      };
      Bookmarks = [
        {
          name = "Nix";
          toolbar = true;
          bookmarks = [
            {
              name = "PKGS";
              url = "https://search.nixos.org/packages";
            }
            {
              name = "Options";
              url = "https://search.nixos.org/options";
            }
            {
              name = "HM Options";
              url = "https://home-manager-options.extranix.com/";
            }
          ];
        }
      ];
    };
    settings = {
      "browser.display.use_document_fonts" = 0;
      "font.name.monospace.x-western" = "JetBrains Mono Nerd Font Medium";
      "font.name.sans-serif.x-western" = "JetBrains Mono Nerd Font Medium";
      "font.name.serif.x-western" = "JetBrains Mono Nerd Font Medium";
      "browser.display.document_color_use" = 0;
      "browser.toolbars.bookmarks.visibility" = "never";
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      "svg.context-properties.content.enabled" = true;
      "browser.startup.page" = 3;
      "privacy.clearOnShutdown_v2.cookiesAndStorage" = false;
      "privacy.clearOnShutdown.cookies" = false;
      "webgl.disabled" = false;
      "privacy.resistFingerprinting" = false;
    };
    profiles.${user} = {
      isDefault = true;
      userChrome = ''
        window,
        #main-window,
        #toolbar-menubar,
        #TabsToolbar,
        #PersonalToolbar,
        #navigator-toolbox,
        #sidebar-box,
        toolbar {
          background-color: #2e3440 !important;
          -moz-appearance: none !important;
          background-image: none !important;
          border: none !important;
        }

        .tab-background[selected="true"] {
          background-color: #4c566a !important;
          -moz-appearance: none !important;
          background-image: none !important;
          border: none !important;
        }

        .tab-background {
          border-radius: 20px !important;
        }

        .tab-line{
          display: none !important;
        }

        .tabbrowser-tab::before,
        .tabbrowser-tab::after{
          display: none !important;
        }

        .tab-close-button {
          border-radius: 10px !important;
        }

        #identity-box,
        #tracking-protection-icon-container,
        #urlbar-background{
          display: none !important;
        }

        #back-button>.toolbarbutton-icon {
          transform: scale(.85, .85) !important;
          animation: none !important;
          border: none !important;
          box-shadow: none !important;
        }

        #back-button:not(:hover),
        #back-button:not(:hover) > .toolbarbutton-icon {
          background: none !important;
        }

        #back-button:hover,
        #back-button:hover > .toolbarbutton-icon {
          border-radius: 2px !important;
        }

        #back-button {
          list-style-image: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAQAAAC1+jfqAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAmJLR0QAAKqNIzIAAAAJcEhZcwAADdcAAA3XAUIom3gAAAAHdElNRQfiAxMSNzVLQoGBAAAAb0lEQVQoz43ROQqDUBSF4UMEESKCBBehOODK7ezSWZnGJmuI4xp+66CX9077FXc40k1o+fCSFRoOOgKLa3Z6QosrNt5EFpesDDwtLlgYSSzOmZlILY758SW7ykO+cYzwWNLjTI9HSc5XS86ypP+6Tw/fVEqhFbEZAAAAJXRFWHRkYXRlOmNyZWF0ZQAyMDE4LTAzLTE5VDE4OjU1OjUzKzAxOjAwq3ccegAAACV0RVh0ZGF0ZTptb2RpZnkAMjAxOC0wMy0xOVQxODo1NTo1MyswMTowMNoqpMYAAAAZdEVYdFNvZnR3YXJlAHd3dy5pbmtzY2FwZS5vcmeb7jwaAAAAAElFTkSuQmCC') !important;
        }

        #forward-button {
          list-style-image: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAQAAAC1+jfqAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAmJLR0QAAKqNIzIAAAAJcEhZcwAADdcAAA3XAUIom3gAAAAHdElNRQfiAxMSOA3k2CXQAAAAbklEQVQoz5WRMQqDABAEF4UgKEIIPkKJii+3s7NLpY1N3qBR84axsPYOt1sYuNtdSZLEi5FG1yKk5U9tIQ86dioLiejZKC0k5sPK20JSBn4UFvJkYiG3kIwvM8npAt2Vc8J50onpFOVU7Y51PfcBtUFUSir+geUAAAAldEVYdGRhdGU6Y3JlYXRlADIwMTgtMDMtMTlUMTg6NTY6MTMrMDE6MDDECqmDAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDE4LTAzLTE5VDE4OjU2OjEzKzAxOjAwtVcRPwAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAAAASUVORK5CYII=') !important;
        }

        #whats-new-menu-button,
        #star-button,
        #pocket-button,
        #pageActionSeparator,
        #pageActionButton,
        #reader-mode-button{
          display: none !important;
        }

        #PanelUI-button {
          border-image-slice: 0 !important;
        }

        #urlbar-results {
          background-color: #3b4252 !important;
          border-radius: 10px !important;
        }

        .urlbarView-body-inner {
          border-top: none !important;
        }

        #nav-bar {
          border-bottom: 0px !important;
          box-shadow: none !important;
        }

        #urlbar ::-moz-selection,
        .searchbar-textbox ::-moz-selection {
          background-color: #dddddd !important;
          color: #000 !important;
        }

        * {
          font-family: "JetBrains Mono Nerd Font" !important;
          font-size: 16px !important;
        }

        #tabbrowser-tabpanels{
          background-color: #ffffff !important;
        }
      '';
    };
  };
}
