# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
args@{ util, self, config, pkgs, lib, ... }:
let
  addons = pkgs.nur.repos.rycee.firefox-addons;
  extensions = {
    clearurls = {
      permissions = [
        "<all_urls>"
        "contextMenus"
        "downloads"
        "storage"
        "tabs"
        "unlimitedStorage"
        "webNavigation"
        "webRequest"
        "webRequestBlocking"
      ];
      private_browsing = true; # TODO
    };
    keepassxc-browser = {
      permissions = [
        "<all_urls>"
        "activeTab"
        "clipboardWrite"
        "contextMenus"
        "cookies"
        "nativeMessaging"
        "notifications"
        "storage"
        "tabs"
        "webNavigation"
        "webRequest"
        "webRequestBlocking"
      ];
    };
    noscript = {
      permissions = [
        "<all_urls>"
        "contextMenus"
        "dns"
        "scripting"
        "storage"
        "tabs"
        "unlimitedStorage"
        "webNavigation"
        "webRequest"
        "webRequestBlocking"
        "webRequestFilterResponse"
        "webRequestFilterResponse.serviceWorkerScript"
      ];
      private_browsing = true; # TODO
    };
    redirector = {
      permissions = [
        "notifications"
        "storage"
        "tabs"
        "webNavigation"
        "webRequest"
        "webRequestBlocking"
      ];
    };
    sponsorblock = {
      permissions = [ "scripting" "storage" "unlimitedStorage" ];
    };
    stylus = {
      permissions = [
        "<all_urls>"
        "alarms"
        "contextMenus"
        "storage"
        "tabs"
        "unlimitedStorage"
        "webNavigation"
        "webRequest"
        "webRequestBlocking"
      ];
    };
    ublock-origin = {
      permissions = [
        "<all_urls>"
        "alarms"
        "dns"
        "file://*/*"
        "menus"
        "privacy"
        "storage"
        "tabs"
        "unlimitedStorage"
        "webNavigation"
        "webRequest"
        "webRequestBlocking"
      ];
      private_browsing = true; # TODO
    };
    violentmonkey = {
      permissions = [
        "<all_urls>"
        "clipboardWrite"
        "contextMenus"
        "cookies"
        "notifications"
        "storage"
        "tabs"
        "unlimitedStorage"
        "webRequest"
        "webRequestBlocking"
      ];
    };
  };
in {
  # catppuccin.zen-browser.enable = true;
  imports = [ args.zen-browser.homeModules.default ];
  home.sessionVariables = {
    MOZ_USE_XINPUT2 = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };
  programs.zen-browser = {
    enable = true;
    nativeMessagingHosts = [ pkgs.keepassxc ];
    languagePacks = [ "en-AU" ];
    policies = {
      AutofillAddressEnabled = true;
      AutofillCreditCardEnabled = false;
      DisableAppUpdate = true; # Managed by Home Manager
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
        SuspectedFingerprinting = true;
        ConvenienceExceptions = false;
        BaselineExceptions = false;
      };
      Cookies = {
        Behavior = "reject-tracker-and-partition-foreign";
        BehaviorPrivateBrowsing = "reject-tracker-and-partition-foreign";
      };
      PasswordManagerEnabled = false;
      Homepage = "homepage-locked";
      OverrideFirstRunPage = "";
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
    };
    profiles = {
      default = {
        isDefault = true;
        containers = { };
        containersForce = true;
        settings = {
          "browser.uiCustomization.state" = {
            placements = {
              widget-overflow-fixed-list = [ ];
              unified-extensions-area =
                builtins.map (x: "${x}-browser-action") [
                  "sponsorblocker_ajay_app"
                  "redirector_einaregilsson_com"
                  "keepassxc-browser_keepassxc_org"
                  "_74145f27-f039-47ce-a470-a662b129930a_"
                  "_aecec67f-0d10-4fa7-b7c7-609a2db280cf_"
                ];
              nav-bar = [
                "back-button"
                "forward-button"
                "stop-reload-button"
                "vertical-spacer"
                "urlbar-container"
                "unified-extensions-button"
                "ublock0_raymondhill_net-browser-action"
                "_73a6fe31-595d-460b-a920-fcc0f8843232_-browser-action"
                "_7a7a4a92-a2a0-41d1-9fd7-1e92480d612d_-browser-action"
              ];
              toolbar-menubar = [ "menubar-items" ];
              TabsToolbar = [ "tabbrowser-tabs" ];
              vertical-tabs = [ ];
              PersonalToolbar = [ "personal-bookmarks" ];
              zen-sidebar-top-buttons = [
                "zen-expand-sidebar-button"
                "print-button"
                "screenshot-button"
                "developer-button"
              ];
              zen-sidebar-foot-buttons = [
                "zen-workspaces-button"
                "downloads-button"
                "history-panelmenu"
                "zen-create-new-button"
              ];
            };
            currentVersion = 23;
            newElementCount = 16;
          };
          "extensions.autoDisableScopes" =
            true; # Automatically install configured extensions
          "browser.preferences.experimental.hidden" = true;
          "zen.view.window.scheme" = 0; # Dark mode
          "zen.view.welcome-screen.seen" = true;
          "zen.welcome-screen.seen" = true;
          "accessibility.browsewithcaret" = false;
          "accessibility.typeaheadfind" = false; # Don't search when typing
          "browser.ctrlTab.sortByRecentlyUsed" =
            false; # Don't Ctrl+Tab by recently used order
          "browser.display.use_document_fonts" = 0; # Override website fonts
          "browser.download.useDownloadDir" =
            false; # Ask where to save downloads
          "browser.link.open_newwindow" = 3; # Open links in new tab, not window
          "browser.preferences.defaultPerformanceSettings.enabled" =
            true; # Recommended performance settings
          "browser.safebrowsing.downloads.remote.url" = "";
          "browser.safebrowsing.enabled" =
            false; # Don't let Google control what websites I visit
          "browser.safebrowsing.provider.google4.dataSharing" = false;
          "browser.search.suggest.enabled" = true; # Search suggestions
          "browser.send_pings" = false;
          "browser.startup.page" = 1; # Start with home page
          "browser.tabs.closeWindowWithLastTab" = false;
          "browser.tabs.warnOnClose" =
            false; # Don't warn before closing multiple tabs
          "browser.urlbar.suggest.clipboard" = false;
          "browser.urlbar.suggest.history" = false;
          "browser.urlbar.suggest.recentsearches" = false;
          "browser.warnOnQuitShortcut" = true; # Warn on Ctrl+Q
          "dom.battery.enabled" = false; # Prevent websites reading battery
          "dom.event.contextmenu.enabled" =
            false; # Prevent websites from preventing right-click
          "font.default.x-western" = "sans-serif";
          "font.name.monospace.x-western" = "monospace";
          "font.name.sans-serif.x-western" = "sans-serif";
          "font.name.serif.x-western" = "serif";
          "general.autoScroll" = true; # Middle-click auto-scrolling
          "general.smoothScroll" = true;
          "intl.accept_languages" = "en-au,en-us,en";
          "intl.regional_prefs.use_os_locales" = true;
          "layers.acceleration.disabled" = true; # Hardware acceleration
          "layout.css.always_underline_links" = false;
          "layout.css.prefers-color-scheme.content-override" = 0; # Dark website appearance
          "media.hardwaremediakeys.enabled" = true;
          "media.videocontrols.picture-in-picture.video-toggle.enabled" = false;
          "network.cookie.cookieBehavior" = 5;
          "network.dns.disablePrefetchFromHTTPS" = true;
          "network.dns.disablePrefetch" = true;
          "network.http.referer.spoofSource" = true; # Send fake referer
          "network.http.sendRefererHeader" =
            2; # Send referer for links and images
          "network.IDN_show_punycode" = true; # Prevent IDN homograph attacks
          "network.prefetch-next" = false;
          "permissions.default.geo" = 2;
          "privacy.clearOnShutdown_v2.cache" = true;
          "privacy.clearOnShutdown_v2.cookiesAndStorage" = true;
          "privacy.sanitize.sanitizeOnShutdown" =
            true; # Clear data when closing
          "privacy.userContext.enabled" = true; # Container tabs
          "sidebar.visibility" = "hide-sidebar";
          "widget.gtk.overlay-scrollbars.enabled" =
            true; # Don't always show scrollbars
          "zen.glance.activation-method" = "ctrl";
          "zen.glance.enabled" = false; # Disable Zen Glance
          "zen.pinned-tab-manager.restore-pinned-tabs-to-pinned-url" =
            true; # Restore pinned tabs
          "zen.tabs.essentials.max" = 0; # I don't use this feature anyway
          "zen.tabs.show-newtab-vertical" =
            true; # Show new tab button in vertical tabs
          "zen.tabs.vertical" = true;
          "zen.tabs.vertical.right-side" = false;
          "zen.ui.migration.compact-mode-button-added" = true;
          "zen.ui.migration.version" = 5;
          "zen.urlbar.behavior" = "normal"; # No floating
          "zen.view.compact.enable-at-startup" = false;
          "zen.view.compact.toolbar-flash-popup" =
            true; # Briefly show tabs in compact mode when switching
          "zen.view.show-newtab-button-top" =
            false; # Show new tab button below tabs instead of above
          "zen.view.sidebar-expanded" = false;
          "zen.view.use-single-toolbar" = false;
          "zen.workspaces.force-container-workspace" = false;
          "zen.workspaces.hide-default-container-indicator" =
            false; # Don't hide container indicator on tab
          "zen.workspaces.separate-essentials" = true;
        };
        search = {
          default = "duckduckgo";
          privateDefault = "duckduckgo";
          order = [
            "duckduckgo"
            "wikipedia"
            "npm"
            "nix-packages"
            "nixos-options"
            "nix-flakes"
            "nixos-wiki"
            "nix-home-manager-options"
            "minecraft-wiki"
            "modrinth"
            "skyblock-official-wiki"
            "skyblock-fandom-wiki"
          ];
          engines = (lib.attrsets.genAttrs [
            # from firefox source code ./services/settings/dumps/main/search-config-v2.json
            "1und1"
            "allegro-pl"
            "amazondotcom-us"
            "azerdict"
            "baidu"
            "bing"
            "bok-NO"
            "ceneji"
            "coccoc"
            "daum-kr"
            "ebay"
            "ebay-at"
            "ebay-au"
            "ebay-be"
            "ebay-ca"
            "ebay-ch"
            "ebay-de"
            "ebay-es"
            "ebay-fr"
            "ebay-ie"
            "ebay-it"
            "ebay-nl"
            "ebay-pl"
            "ebay-uk"
            "ecosia"
            "eudict"
            "faclair-beag"
            "gmx-de"
            "gmx-en-GB"
            "gmx-es"
            "gmx-fr"
            "gmx-shopping"
            "google"
            "gulesider-NO"
            "leo_ende_de"
            "longdo"
            "mailcom"
            "mapy-cz"
            "mercadolibre-ar"
            "mercadolibre-cl"
            "mercadolibre-mx"
            "mercadolivre"
            "naver-kr"
            "odpiralni"
            "pazaruvaj"
            "perplexity"
            "priberam"
            "prisjakt-sv-SE"
            "qwant"
            "qwantjr"
            "rakuten"
            "readmoo"
            "reddit"
            "salidzinilv"
            "seznam-cz"
            "tyda-sv-SE"
            "vatera"
            "webde"
            "wolnelektury-pl"
            "yahoo-jp"
            "yahoo-jp-auctions"
            "youtube"
            "ddg"
            "duckduckgo"
          ] (_: { metaData.hidden = true; })) // {
            duckduckgo = {
              name = "DuckDuckGo (modified)";
              urls = [{
                template = with builtins.mapAttrs
                  (name: value: util.replacePrefix value.hex "#" "")
                  (util.getPalette config);
                # See https://duckduckgo.com/duckduckgo-help-pages/settings/params
                  "https://noai.duckduckgo.com/?kae=d&kao=-1&kap=-1&kpsb=-1&kl=wt-wt&kax=-1&kak=-1&kau=-1&k1=-1&kay=b&kk=-1&kdcm=1&k5=2&kw=w&kav=1&kaq=-1&kaj=m&kdcs=1&kbe=0&kj=${mantle}&kaa=${mauve}&k21=${base}&k7=${base}&kx=${subtext1}&k9=${pink}&k8=${text}&kt=sans-serif&ka=sans-serif&kbg=-1&kbi=1&kbc=1&q={searchTerms}";
              }];
              iconMapObj."16" =
                "https://static-production.npmjs.com/c426a1116301d1fd178c51522484127a.png";
              definedAliases = [ "duckduckgo" "ddg" ];
            };
            wikipedia = { };
            npm = {
              name = "npm";
              urls = [{
                template = "https://www.npmjs.com/search?q={searchTerms}";
              }];
              iconMapObj."16" =
                "https://static-production.npmjs.com/c426a1116301d1fd178c51522484127a.png";
              definedAliases = [ "npm" ];
            };
            nix-packages = {
              name = "Nixpkgs";
              urls = [{
                template =
                  "https://search.nixos.org/packages?query={searchTerms}";
              }];
              iconMapObj."16" = "https://search.nixos.org/favicon.png";
              definedAliases = [ "nixpkgs" ];
            };
            nixos-options = {
              name = "NixOS options";
              urls = [{
                template =
                  "https://search.nixos.org/options?query={searchTerms}";
              }];
              iconMapObj."16" = "https://search.nixos.org/favicon.png";
              definedAliases = [ "nixosopts" "nixopt" "nixopts" ];
            };
            nix-flakes = {
              name = "Nix Flakes";
              urls = [{
                template =
                  "https://search.nixos.org/flakes?query={searchTerms}";
              }];
              iconMapObj."16" = "https://search.nixos.org/favicon.png";
              definedAliases = [ "nixflakes" ];
            };
            nixos-wiki = {
              name = "NixOS Wiki";
              urls = [{
                template =
                  "https://wiki.nixos.org/w/index.php?search={searchTerms}";
              }];
              iconMapObj."16" = "https://search.nixos.org/favicon.png";
              definedAliases = [ "nixoswiki" "nixwiki" "nw" ];
            };
            nix-home-manager-options = {
              name = "Nix Home Manager Options";
              urls = [{
                template =
                  "https://home-manager-options.extranix.com/?query={searchTerms}";
              }];
              iconMapObj."16" = "https://search.nixos.org/favicon.png";
              definedAliases = [ "nixhome" "homemanager" ];
            };
            minecraft-wiki = {
              name = "Minecraft Wiki";
              urls = [{
                template =
                  "https://minecraft.wiki/w/Special:Search?search={searchTerms}";
              }];
              iconMapObj."16" = "https://minecraft.wiki/images/Favicon.ico";
              definedAliases = [ "mc" ];
            };
            modrinth = {
              name = "Modrinth";
              urls =
                [{ template = "https://modrinth.com/mods?q={searchTerms}"; }];
              iconMapObj."16" = "https://modrinth.com/favicon.ico";
              definedAliases = [ "mod" ];
            };
            skyblock-official-wiki = {
              name = "Official SkyBlock Wiki";
              urls = [{
                template =
                  "https://wiki.hypixel.net/index.php?search={searchTerms}";
              }];
              iconMapObj."16" = "https://hypixel.net/favicon-32x32.png";
              definedAliases = [ "sbh" ];
            };
            skyblock-fandom-wiki = {
              name = "Fandom SkyBlock Wiki";
              urls = [{
                template =
                  "https://hypixel-skyblock.fandom.com/wiki/Special:Search?query={searchTerms}";
              }];
              iconMapObj."16" = "https://hypixel.net/favicon-32x32.png";
              definedAliases = [ "sbf" ];
            };
          };
          force = true;
        };
      };
    };
    profiles.default = {
      extensions.force = true;
      extensions.packages =
        lib.mapAttrsToList (extension: attr: addons.${extension}) extensions;
    };
  };
  assertions = lib.mapAttrsToList (extension: attr:
    (let
      ext = addons.${extension};
      # Some extensions have permissions with massive lists of domains so I'm just gonna allow them all by default
      removeUrlPermissions = x:
        (builtins.filter
          (perm: builtins.isNull (builtins.match "^(https?|\\*)://.*$" perm))
          x);
    in {
      assertion = util.listEquals attr.permissions
        (removeUrlPermissions ext.meta.mozPermissions);
      message = "Extension ${extension} wants permissions [${
          builtins.concatStringsSep " "
          (builtins.map lib.strings.escapeNixString
            (builtins.sort builtins.lessThan
              (removeUrlPermissions ext.meta.mozPermissions)))
        }] but [${
          builtins.concatStringsSep " "
          (builtins.map lib.strings.escapeNixString
            (builtins.sort builtins.lessThan attr.permissions))
        }] was specified. See https://developer.mozilla.org/docs/Mozilla/Add-ons/WebExtensions/manifest.json/permissions#api_permissions for a list of permissions.";
    })) extensions;
}
