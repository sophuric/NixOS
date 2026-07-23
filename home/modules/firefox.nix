# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
args@{
  util,
  config,
  pkgs,
  lib,
  ...
}:
let
  addons = pkgs.nur.repos.rycee.firefox-addons;
  extensions =
    let
      palette = util.getPalette config;
    in
    {
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
          "*://*.yandex.ru/*"
          "*://*.yandex.com/*"
          "*://*.ya.ru/*"
        ]
        ++ (builtins.map (x: "*://*.${x}/*") (import ../util/google-domains.nix));
        # private_browsing = true; # TODO
        settings = {
          badgedStatus = true;
          globalStatus = true;
          badged_color = palette.pink.hex;
          hashURL = "https://rules2.clearurls.xyz/rules.minify.hash";
          ruleURL = "https://rules2.clearurls.xyz/data.minify.json";
          contextMenuEnabled = true;
          historyListenerEnabled = true;
          localHostsSkipping = true;
          referralMarketing = false;
          domainBlocking = true;
          pingBlocking = true;
          eTagFiltering = false;
          types = "font,image,imageset,main_frame,media,object,object_subrequest,other,script,stylesheet,sub_frame,websocket,xml_dtd,xmlhttprequest,xslt";
        };
        force = true;
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
          "https://*/*"
          "http://*/*"
          "https://api.github.com/"
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
        # private_browsing = true; # TODO
      };
      sponsorblock = {
        permissions = [
          "scripting"
          "storage"
          "unlimitedStorage"
          "https://sponsor.ajay.app/*"
          "https://*.youtube.com/*"
          "https://www.youtube-nocookie.com/embed/*"
        ];
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
          "https://userstyles.org/*"
        ];
      };
      ublock-origin = {
        permissions = [
          "<all_urls>"
          "alarms"
          "dns"
          "file://*/*"
          "http://*/*"
          "https://*/*"
          "https://easylist.to/*"
          "https://*.fanboy.co.nz/*"
          "https://filterlists.com/*"
          "https://forums.lanik.us/*"
          "https://github.com/*"
          "https://*.github.io/*"
          "https://github.com/uBlockOrigin/*"
          "https://ublockorigin.github.io/*"
          "https://*.reddit.com/r/uBlockOrigin/*"
          "menus"
          "privacy"
          "storage"
          "tabs"
          "unlimitedStorage"
          "webNavigation"
          "webRequest"
          "webRequestBlocking"
        ];
        settings = {
          userSettings = {
            uiAccentCustom = true;
            uiAccentCustom0 = "#f5c2e7";
          };
          selectedFilterLists = [
            "user-filters"
            "ublock-filters"
            "ublock-badware"
            "ublock-privacy"
            "ublock-unbreak"
            "ublock-quick-fixes"
            "easylist"
            "easyprivacy"
            "urlhaus-1"
            "plowe-0"
            "fanboy-cookiemonster"
            "ublock-cookies-easylist"
            "adguard-cookies"
            "ublock-cookies-adguard"
            "fanboy-social"
            "adguard-social"
            "fanboy-thirdparty_social"
            "fanboy-ai-suggestions"
            "easylist-chat"
            "easylist-newsletters"
            "easylist-notifications"
            "easylist-annoyances"
            "adguard-mobile-app-banners"
            "adguard-other-annoyances"
            "adguard-popup-overlays"
            "adguard-widgets"
            "ublock-annoyances"
          ];
        };
        # private_browsing = true; # TODO
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
      blocktube = {
        permissions = [
          "storage"
          "unlimitedStorage"
          "https://www.youtube.com/*"
          "https://m.youtube.com/*"
        ];
      };
      return-youtube-dislikes = {
        permissions = [
          "activeTab"
          "*://*.youtube.com/*"
          "storage"
          "*://returnyoutubedislikeapi.com/*"
        ];
      };
    };
in
{
  catppuccin.firefox.enable = true;
  home.sessionVariables = {
    MOZ_USE_XINPUT2 = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };
  programs.firefox = {
    enable = true;
    configPath = "${config.xdg.configHome}/mozilla/firefox";
    nativeMessagingHosts = [ pkgs.keepassxc ];
    languagePacks = [ "en-AU" ];
    policies = {
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      # Disable updating because it's managed by Nix
      AppAutoUpdate = false;
      BackgroundAppUpdate = false;
      DisableAppUpdate = true;
      # Disable telemetry and stuff
      DisableFeedbackCommands = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DisableFirefoxAccounts = true;
      DisableRemoteImprovements = true;
      DisableSetDesktopBackground = true;
      DontCheckDefaultBrowser = true;
      Containers = [ ]; # Remove initial set of containers
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
      OfferToSaveLoginsDefault = false;
      PasswordManagerEnabled = false; # Use KeePassXC instead
      NetworkPrediction = false; # DNS prefetching
      DNSOverHTTPS.Enabled = false; # use system-level DoH
      SanitizeOnShutdown = {
        Cache = true;
        Cookies = true;
        FormData = true;
        History = false;
        Sessions = true;
        SiteSettings = false;
        Locked = true;
      };
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
        # Reject tracker cookies and partition third-party cookies
        Behavior = "reject-tracker-and-partition-foreign";
        BehaviorPrivateBrowsing = "reject-tracker-and-partition-foreign";
        Locked = true;
      };
      Homepage = "homepage-locked";
      OverrideFirstRunPage = "";
      AIControls = {
        Translations = {
          Value = "available";
          Locked = true;
        };
      }
      // (lib.attrsets.genAttrs
        [
          "Default"
          "PDFAltText"
          "SmartTabGroups"
          "LinkPreviewKeyPoints"
          "SidebarChatbot"
          "SmartWindow"
        ]
        (_: {
          Value = "blocked";
          Locked = true;
        })
      );
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
      FirefoxSuggest = {
        WebSuggestions = true;
        SponsoredSuggestions = false;
        ImproveSuggest = false;
        Locked = true;
      };
    };
    profiles = {
      default = {
        isDefault = true;
        containers = { };
        containersForce = true;
        settings = {
          # Disable about:config warning
          "browser.aboutConfig.showWarning" = false;
          # Enable translating websites
          "browser.ai.control.translations" = true;
          # Disable sponsored content on new tab page
          "browser.newtabpage.activity-stream.showSponsoredCheckboxes" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "extensions.autoDisableScopes" = true;
          "browser.toolbars.bookmarks.visibility" = "always";
          "accessibility.browsewithcaret" = false;
          # Don't search when typing
          "accessibility.typeaheadfind" = false;
          # Don't Ctrl+Tab by recently used order
          "browser.ctrlTab.sortByRecentlyUsed" = false;
          # Override website fonts
          "browser.display.use_document_fonts" = 0;
          # Ask where to save downloads
          "browser.download.useDownloadDir" = false;
          # Open links in new tab, not window
          "browser.link.open_newwindow" = 3;
          # Recommended performance settings
          "browser.preferences.defaultPerformanceSettings.enabled" = false;
          "browser.safebrowsing.downloads.remote.url" = "";
          "browser.safebrowsing.downloads.enabled" = false;
          # I find this an annoyance
          "browser.safebrowsing.downloads.remote.block_potentially_unwanted" = false;
          "browser.safebrowsing.downloads.remote.block_uncommon" = false;
          "browser.safebrowsing.malware.enabled" = false;
          "browser.safebrowsing.phishing.enabled" = false;
          # Don't let Google control what websites I visit
          "browser.safebrowsing.enabled" = false;
          "browser.safebrowsing.provider.google4.dataSharing" = false;
          "browser.preferences.config_warning.warningSafeBrowsing.dismissed" = true;
          # Use WM for split view
          "browser.tabs.splitView.enabled" = false;
          "browser.tabs.inTitlebar" = 1;
          "browser.search.suggest.enabled" = true; # Search suggestions
          "browser.send_pings" = false;
          "browser.startup.page" = 1; # Start with home page
          "browser.tabs.closeWindowWithLastTab" = false;
          # Don't warn before closing multiple tabs
          "browser.tabs.warnOnClose" = false;
          "browser.urlbar.suggest.clipboard" = false;
          "browser.urlbar.suggest.history" = false;
          "browser.urlbar.suggest.recentsearches" = false;
          "browser.warnOnQuitShortcut" = true; # Warn on Ctrl+Q
          "dom.battery.enabled" = false; # Prevent websites reading battery
          # Prevent websites from preventing right-click
          "dom.event.contextmenu.enabled" = false;
          "font.default.x-western" = "sans-serif";
          "font.name.monospace.x-western" = "monospace";
          "font.name.sans-serif.x-western" = "sans-serif";
          "font.name.serif.x-western" = "serif";
          "general.autoScroll" = true; # Middle-click auto-scrolling
          "general.smoothScroll" = true;
          "intl.accept_languages" = "en-au,en-us,en";
          "intl.regional_prefs.use_os_locales" = true;
          "layers.acceleration.disabled" = false; # Hardware acceleration
          "layout.css.always_underline_links" = false;
          # Dark website appearance
          "layout.css.prefers-color-scheme.content-override" = 0;
          "media.hardwaremediakeys.enabled" = true;
          "media.videocontrols.picture-in-picture.video-toggle.enabled" = false;
          "network.cookie.cookieBehavior" = 5;
          "network.dns.disablePrefetchFromHTTPS" = true;
          "network.dns.disablePrefetch" = true;
          "network.http.referer.spoofSource" = true; # Send fake referer
          # Send referer for links and images
          "network.http.sendRefererHeader" = 2;
          "network.IDN_show_punycode" = true; # Prevent IDN homograph attacks
          "network.prefetch-next" = false;
          "permissions.default.geo" = 2;
          # Tell websites not to sell/share my data - https://globalprivacycontrol.org
          "privacy.globalprivacycontrol.enabled" = true;
          "privacy.globalprivacycontrol.was_ever_enabled" = true;
          # Clear cache, cookies, and local storage on shutdown
          "privacy.clearOnShutdown_v2.cache" = true;
          "privacy.clearOnShutdown_v2.cookiesAndStorage" = true;
          # Don't clear history
          "privacy.clearOnShutdown_v2.browsingHistoryAndDownloads" = false;
          # Clear data when closing
          "privacy.sanitize.sanitizeOnShutdown" = true;
          "privacy.userContext.enabled" = true; # Container tabs
          # New sidebar
          "browser.toolbarbuttons.introduced.sidebar-button" = true;
          "sidebar.revamp" = true;
          "sidebar.verticalTabs" = true;
          "sidebar.verticalTabs.dragToPinPromo.dismissed" = true;
          "sidebar.visibility" = "expand-on-hover";
          # Remove synced tabs button
          "sidebar.main.tools" = "history,bookmarks";
          # Don't always show scrollbars
          "widget.gtk.overlay-scrollbars.enabled" = true;
        };
        search = {
          default = "duckduckgo";
          privateDefault = "duckduckgo";
          order = [
            "duckduckgo"
            "youtube"
            "wikipedia"
            "npm"
            "nix-packages"
            "nixos-options"
            "nix-flakes"
            "nixos-wiki"
            "minecraft-wiki"
            "modrinth"
            "skyblock-official-wiki"
            "skyblock-community-wiki"
            "factorio-wiki"
            "factorio-mods"
          ];
          engines =
            (lib.attrsets.genAttrs
              [
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
                "ddg"
                "duckduckgo"
              ]
              (_: {
                metaData.hidden = true;
              })
            )
            // {
              duckduckgo = {
                name = "DuckDuckGo -";
                urls = [
                  {
                    template =
                      with builtins.mapAttrs (name: value: util.replacePrefix value.hex "#" "") (util.getPalette config);
                      # See https://duckduckgo.com/duckduckgo-help-pages/settings/params
                      "https://noai.duckduckgo.com/?kae=d&kau=-1&kaj=m&kav=1&k1=-1&kay=b&kak=-1&kaq=-1&kap=-1&kao=-1&kax=-1&kw=s&k7=${base}&kj=${mantle}&k9=${pink}&kaa=${mauve}&k21=${mantle}&kbg=-1&kbe=0&k5=2&k8=cdd6f4&kx=bac2de&kpsb=-1&ka=sans-serif&kt=sans-serif&km=l&kbj=1&ks=l&ko=1&q={searchTerms}";
                  }
                ];
                iconMapObj."16" = "https://duckduckgo.com/favicon.png";
                definedAliases = [
                  "@duckduckgo"
                  "@ddg"
                ];
              };
              npm = {
                name = "npm";
                urls = [
                  {
                    template = "https://www.npmjs.com/search?q={searchTerms}";
                  }
                ];
                iconMapObj."16" = "https://static-production.npmjs.com/c426a1116301d1fd178c51522484127a.png";
                definedAliases = [ "@npm" ];
              };
              nix-packages = {
                name = "Nixpkgs";
                urls = [
                  {
                    template = "https://search.nixos.org/packages?query={searchTerms}";
                  }
                ];
                iconMapObj."16" = "https://nixos.org/favicon.ico";
                definedAliases = [ "@nixpkgs" ];
              };
              nixos-options = {
                name = "NixOS options";
                urls = [
                  {
                    template = "https://search.nixos.org/options?query={searchTerms}";
                  }
                ];
                iconMapObj."16" = "https://nixos.org/favicon.ico";
                definedAliases = [
                  "@nixosopts"
                  "@nixopt"
                  "@nixopts"
                ];
              };
              nix-flakes = {
                name = "Nix Flakes";
                urls = [
                  {
                    template = "https://search.nixos.org/flakes?query={searchTerms}";
                  }
                ];
                iconMapObj."16" = "https://nixos.org/favicon.ico";
                definedAliases = [ "@nixflakes" ];
              };
              nixos-wiki = {
                name = "NixOS Wiki";
                urls = [
                  {
                    template = "https://wiki.nixos.org/w/index.php?search={searchTerms}";
                  }
                ];
                iconMapObj."16" = "https://nixos.org/favicon.ico";
                definedAliases = [
                  "@nixoswiki"
                  "@nixwiki"
                  "@nw"
                ];
              };
              minecraft-wiki = {
                name = "Minecraft Wiki";
                urls = [
                  {
                    template = "https://minecraft.wiki/w/Special:Search?search={searchTerms}";
                  }
                ];
                iconMapObj."16" = "https://minecraft.wiki/images/Favicon.ico";
                definedAliases = [
                  "@mc"
                  "@minecraft"
                ];
              };
              modrinth = {
                name = "Modrinth";
                urls = [ { template = "https://modrinth.com/mods?q={searchTerms}"; } ];
                iconMapObj."16" = "https://modrinth.com/favicon.ico";
                definedAliases = [ "@mod" ];
              };
              hypixel-skyblock-wiki = {
                name = "Hypixel SkyBlock Wiki";
                urls = [
                  {
                    template = "https://hypixelskyblock.minecraft.wiki/w/Special:Search?search={searchTerms}";
                  }
                ];
                iconMapObj."16" = "https://hypixel.net/favicon-32x32.png";
                definedAliases = [
                  "@sb"
                  "@sbf"
                  "@sbc"
                ];
              };
              factorio-wiki = {
                name = "Factorio Wiki";
                urls = [
                  {
                    template = "https://wiki.factorio.com/index.php?search={searchTerms}";
                  }
                ];
                iconMapObj."16" = "https://wiki.factorio.com/favicon.ico";
                definedAliases = [
                  "@fw"
                  "@factorio-wiki"
                  "@factoriowiki"
                ];
              };
              factorio-mods = {
                name = "Factorio Mods";
                urls = [
                  {
                    template = "https://mods.factorio.com/search?query={searchTerms}";
                  }
                ];
                iconMapObj."16" = "https://mods.factorio.com/static/favicon.ico";
                definedAliases = [
                  "@fm"
                  "@factorio-mods"
                  "@factoriomods"
                ];
              };
            };
          force = true;
        };
        extensions = {
          force = true;
          exactPermissions = true;
          packages = lib.mapAttrsToList (extension: attr: addons.${extension}) extensions;
          settings = util.merge (
            builtins.attrValues (
              builtins.mapAttrs (name: value: { ${addons.${name}.addonId} = value; }) extensions
            )
          );
        };
      };
    };
  };
}
