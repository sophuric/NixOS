# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
args@{ defaultFonts, self, config, pkgs, lib, ... }: {
  enable = true;
  nativeMessagingHosts = [ pkgs.keepassxc ];
  profiles = { default = { }; };
  policies = {
    AutofillAddressEnabled = true;
    AutofillCreditCardEnabled = false;
    DisableAppUpdate = true;
    DisableFeedbackCommands = true;
    DisableFirefoxStudies = true;
    DisablePocket = true;
    DisableTelemetry = true;
    DontCheckDefaultBrowser = true;
    NoDefaultBookmarks = true;
    OfferToSaveLogins = false;
    DisableSetDesktopBackground = true;
    DNSOverHTTPS.Enabled = false; # use system-level DoH
    EnableTrackingProtection = {
      Value = true;
      Locked = true;
      Cryptomining = true;
      Fingerprinting = true;
    };
    GenerativeAI = {
      # ew
      Chatbot = false;
      LinkPreviews = false;
      TabGroups = false;
      Locked = true;
    };
    HttpsOnlyMode = "force_enabled";
    FirefoxHome = {
      Search = true;
      TopSites = false;
      SponsoredTopSites = false;
      Highlights = false;
      Pocket = false;
      SponsoredPocket = false;
      Snippets = false;
      Locked = true;
    };
    ExtensionSettings = builtins.mapAttrs (_: pluginId: {
      install_url =
        "https://addons.mozilla.org/firefox/downloads/latest/${pluginId}/latest.xpi";
      installation_mode = "force_installed";
    }) { };
    Preferences = builtins.mapAttrs (_: value: {
      Value = value;
      Status = "locked";
    }) {
      font.default.x-western = "sans-serif";
      font.name.sans-serif.x-western = args.first defaultFonts.sansSerif;
      font.name.serif.x-western = args.first defaultFonts.serif;
      font.name.monospace.x-western = args.first defaultFonts.monospace;
      network.dns.disablePrefetch = true;
      network.prefetch-next = false;
      permissions.default.geo = 2;
      intl.accept_languages = "en-au,en-us,en";
      intl.regional_prefs.use_os_locales = true;
      zen.pinned-tab-manager.restore-pinned-tabs-to-pinned-url = true;
      zen.ui.migration.compact-mode-button-added = true;
      zen.ui.migration.version = 5;
      zen.urlbar.behavior = "normal";
      zen.view.compact.enable-at-startup = false;
      zen.view.show-newtab-button-top = false;
      zen.view.sidebar-expanded = false;
      zen.view.use-single-toolbar = false;
      zen.view.welcome-screen.seen = true;
      sidebar.visibility = "hide-sidebar";
    };
  };
}
