{
  programs.librewolf = {
    enable = true;
    languagePacks = [ "en-US" ];

    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;

      # ================================================================================================
      # CSS
      # ================================================================================================

      userChrome = ''
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

        .titlebar-buttonbox,
        .titlebar-spacer,
        #forward-button,
        #back-button,
        #tracking-protection-icon-container,
        #page-action-buttons,
        #PanelUI-button,
        #identity-box,
        #tracking-protection-icon-container,
        #page-action-buttons > :not(#urlbar-zoom-button, #star-button-box),
        #urlbar-go-button,
        #alltabs-button,
        .titlebar-buttonbox-container,
        #reload-button,
        #new-tab-button,
        #widget-overflow,
        #widget-overflow-button,
        #customization-panelWrapper,
        #unified-extensions-area,
        #unified-extensions-button {
          display: none !important;
        }
      '';
    };

    # ================================================================================================
    # about:policies
    # ================================================================================================

    policies = {

      # Privacy
      DisablePocket = true;
      DisableAccounts = true;
      DisableTelemetry = true;
      DisableFormHistory = true;
      DisableHealthReport = true;
      DisableCrashReporter = true;
      DisableFirefoxStudies = true;
      DisableFirefoxAccounts = true;
      DisableFeedbackCommands = true;
      DisableFirefoxScreenshots = true;

      DisableProfileImport = true;
      DisableSetDesktopBackground = true;

      OfferToSaveLogins = false;
      PasswordManagerEnabled = false;
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;

      # Security
      PrintingEnabled = false;
      HttpsOnlyMode = "enabled";

      # Style
      NewTabPage = false;
      ShowHomeButton = false;
      DisplayBookmarksToolbar = "always";

      # Misc 
      TranslateEnabled = false;
      NoDefaultBookmarks = true;
      SanitizeOnShutdown = false;

      # ================================================================================================
      # about:config
      # ================================================================================================

      Preferences = {

        "browser.uidensity" = 1;
        "browser.startup.page" = 3;
        "browser.compactmode.show" = true;
        "browser.display.os-zoom-behavior" = 0;
        "browser.ctrlTab.sortByRecentlyUsed" = true;
        "browser.contentblocking.category" = "strict";
        "browser.bookmarks.restore_default_bookmarks" = false;

        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.startup.homepage" = "chrome://browser/content/blanktab.html";

        # ✅ Privacy Essentials
        "privacy.firstparty.isolate" = true;
        "privacy.resistFingerprinting" = true;
        "privacy.resistFingerprinting.pbmode" = true;
        "privacy.resistFingerprinting.letterboxing" = false;

        "privacy.fingerprintingProtection" = true;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.pbmode.enabled" = true;
        "privacy.trackingprotection.cryptomining.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "privacy.trackingprotection.fingerprinting.enabled" = true;

        "privacy.partition.network_state" = true;
        "privacy.partition.serviceWorkers" = true;
        "privacy.partition.always_partition_third_party_non_cookie_storage" = true;

        "privacy.query_stripping.enabled" = true;
        "privacy.query_stripping.enabled.pbmode" = true;

        "privacy.purge_trackers.enabled" = true;

        # ✅ Sanitize on shutdown
        "privacy.clearOnShutdown.cache" = true;
        "privacy.clearOnShutdown.history" = true;
        "privacy.clearOnShutdown.formdata" = true;
        "privacy.clearOnShutdown.sessions" = true;
        "privacy.clearOnShutdown.downloads" = true;
        "privacy.clearOnShutdown.openWindows" = true;

        "privacy.clearOnShutdown.cookies" = false;
        "privacy.sanitize.sanitizeOnShutdown" = false;
        "privacy.clearOnShutdown.siteSettings" = false;

        # ✅ Do Not Track + GPC
        "privacy.donottrackheader.enabled" = true;
        "privacy.globalprivacycontrol.enabled" = true;
        "privacy.globalprivacycontrol.pbmode.enabled" = true;
        "privacy.globalprivacycontrol.functionality.enabled" = true;

        # ✅ Misc protections
        "privacy.userContext.enabled" = false; # Enable container tabs
        "privacy.reduceTimerPrecision" = true;
        "privacy.window.name.update.enabled" = true;
        "privacy.resistFingerprinting.reduceTimerPrecision.jitter" = true;

        # 🔐 HTTPS-only and HTTPS-first policies
        "dom.security.https_only_mode" = true;
        "dom.security.https_only_mode_pbm" = true;
        "dom.security.https_only_mode.upgrade_local" = false;
        "dom.security.https_only_mode.upgrade_onion" = false;
        "dom.security.https_only_mode_error_page_user_suggestions" = false;
        "dom.security.https_first" = true;
        "dom.security.https_first_pbm" = true;

        # ✅ OCSP and Cert security
        "security.OCSP.enabled" = 1;
        "security.OCSP.require" = true;
        "security.ssl.enable_ocsp_stapling" = true;
        "security.ssl.enable_ocsp_must_staple" = true;
        "security.pki.crlite_mode" = 2;
        "security.pki.certificate_transparency.mode" = 2;

        # 🛡️ SSL/TLS config
        "security.ssl.require_safe_negotiation" = true;
        "security.ssl.treat_unsafe_negotiation_as_broken" = true;
        "security.tls.version.min" = 3;
        "security.tls.version.max" = 4;
        "security.tls.enable_0rtt_data" = false;
        "security.tls.enable_delegated_credentials" = true;

        # ✅ Certificate pinning and protections
        "security.cert_pinning.enforcement_level" = 2;
        "security.ssl.disable_session_identifiers" = false;

        # ✅ CSP and JavaScript hardening
        "security.csp.truncate_blocked_uri_for_frame_navigations" = true;
        "security.browser_xhtml_csp.enabled" = true;

        # 🔒 Sandbox + Eval protections
        "security.allow_eval_with_system_principal" = false;
        "security.allow_eval_in_parent_process" = false;
        "security.sandbox.content.level" = 4;
        "security.sandbox.warn_unprivileged_namespaces" = true;

        # 🔐 Mixed content blocking
        "security.mixed_content.block_active_content" = true;
        "security.mixed_content.upgrade_display_content" = true;

        # ✅ Certificate management
        "security.default_personal_cert" = "Ask Every Time";
        "security.remember_cert_checkbox_default_setting" = true;

        # ✅ Warnings for insecure forms
        "security.warn_submit_secure_to_insecure" = true;

        # ✅ WebAuthn tightened
        "security.webauthn.enable_conditional_mediation" = true;
        "security.webauthn.ctap2" = true;

        # ✅ Miscellaneous hardening
        "security.data_uri.block_toplevel_data_uri_navigations" = true;
        "security.fileuri.strict_origin_policy" = true;
        "security.allow_unsafe_parent_loads" = false;
        "security.dialog_enable_delay" = 1000;

        # 🚫 Disable experimental or less secure features
        "dom.security.featurePolicy.experimental.enabled" = false;
        "dom.security.trusted_types.enabled" = false;
        "dom.security.sanitizer.enabled" = false;

        # 📈 Disable telemetry related to security
        "security.protectionspopup.recordEventTelemetry" = false;
        "security.unexpected_system_load_telemetry_enabled" = false;

        # ✅ Strict Transport Security preload list
        "network.stricttransportsecurity.preloadlist" = true;

      };

      # ================================================================================================
      # about:support
      # ================================================================================================

      ExtensionSettings = {

        # uBlock Origin
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
          default_area = "";
        };

        # Dark Reader
        "addon@darkreader.org" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
          installation_mode = "force_installed";
          default_area = "";
        };

        # ClearURLs
        "{74145f27-f039-47ce-a470-a662b129930a}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/clearurls/latest.xpi";
          installation_mode = "force_installed";
          default_area = "";
        };

        # I still don't care about cookies
        "idcac-pub@guus.ninja" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/istilldontcareaboutcookies/latest.xpi";
          installation_mode = "force_installed";
          default_area = "";
        };

        # Catppuccin Motcha Mauve
        "{76aabc99-c1a8-4c1e-832b-d4f2941d5a7a}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/catppuccin-mocha-mauve-git/latest.xpi";
          installation_mode = "force_installed";
        };
      };
    };
  };
}
