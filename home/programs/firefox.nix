{ pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-esr;

    profiles = {
      default = {
        # extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        #   ublock-origin
        #   vimium
        #   sponsorblock
        #   youtube-recommended-videos
        #   scroll_anywhere
        #   newtab-adapter
        #   plasma-integration
        # ];
      };

      settings = {

        webgl.disabled = true;
        "layers.acceleration.force-enabled" = true;
        toolkit.legacyUserProfileCustomizations.stylesheets = true;

        # ----------------------------------------------
        # Browser
        # ----------------------------------------------

        browser.aboutConfig.showWarning = false;


        browser.uidensity = 1;
        compactmode.show = true;
        tabs.warnOnClose = false;


        aboutwelcome.enabled = false;
        bookmarks.restore_default_bookmarks = false;
        contentblocking.category = "standard";
        ctrlTab.sortByRecentlyUsed = true;

        newtabpage = {
          enabled = false;

          activity-stream = {
            showSearch = false;
            newtabpage.activity-stream.showSponsored = false;
            newtabpage.activity-stream.showSponsoredTopSites = false;
            newtabpage.activity-stream.showWeather = false;
            newtabpage.activity-stream.system.showSponsored = false;
          };
        };

        # ----------------------------------------------
        # Sensors
        # ----------------------------------------------

        device.sensors.enabled = false;
        device.sensors.motion.enabled = false;
        extensions.pocket.enabled = false;

        geo.enabled = false;

        # ----------------------------------------------
        # Network
        # ----------------------------------------------

        network.trr.custom_uri = "https://dns.quad9.net/dns-query";
        network.trr.uri = "https://dns.quad9.net/dns-query";

        # ----------------------------------------------
        # Privacy
        # ----------------------------------------------

        privacy = {
          bounceTrackingProtection.hasMigratedUserActivationData = true;
          donottrackheader.enabled = true;
          fingerprintingProtection = true;
          globalprivacycontrol.enabled = true;
          globalprivacycontrol.was_ever_enabled = true;
          resistFingerprinting = true;
        };

        # ----------------------------------------------
        # Services
        # ----------------------------------------------

        services.sync.engine.addons = false;
        services.sync.nextSync = 0;

        signon.firefoxRelay.feature = "disabled";
        signon.generation.enabled = "false";
      };

      # ----------------------------------------------
      # CSS
      # ----------------------------------------------

      userChrome = ''
        /* =========================================================================================================
          Styling
        ==========================================================================================================*/

        #navigator-toolbox {
          display: flex;
          flex-direction: row;
          flex-wrap: wrap;
        }

        #TabsToolbar {
          order: 1;
          flex: 0 0 70%;
          position: relative;
          margin-left: -21.8vw !important;
        }

        #nav-bar {
          order: 2;
          flex: 0 0 30%;
          border: transparent !important;
          background: transparent !important;
        }

        #PersonalToolbar {
          order: 3;
          width: 100%;
        }

        #urlbar-container {
          width: auto !important;
        }

        #urlbar {
          background: transparent !important;
          border: none !important;
          box-shadow: none !important;
        }

        /* =========================================================================================================
          Remove items
        ==========================================================================================================*/

        .titlebar-buttonbox,
        .titlebar-spacer,
        #forward-button,
        #back-button,
        #tracking-protection-icon-container,
        #page-action-buttons,
        #PanelUI-button,
        #identity-box,
        #tracking-protection-icon-container,
        #page-action-buttons> :not(#urlbar-zoom-button, #star-button-box),
        #urlbar-go-button,
        #alltabs-button,
        .titlebar-buttonbox-container {
          display: none !important;
        }
      '';
    };
  };
}
