# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
args@{ self, config, lib, pkgs, ... }:
let
  defaultFonts = {
    serif = [ "Liberation Serif" ];
    sansSerif = [ "Ubuntu Sans" "Cantarell" "FreeSans" ];
    monospace =
      [ "Cartograph CF" "Fira Code" "FiraCode Nerd Font Mono" "Fira Mono" ];
    emoji = [ "Twitter Color Emoji" ];
  };
in {
  imports = [ args.zen-browser.homeModules.twilight ./nvim.nix ];

  manual.html.enable = true;
  manual.manpages.enable = true;

  fonts.fontconfig = {
    enable = true;
    inherit defaultFonts;
  };

  catppuccin = {
    accent = "pink";
    flavor = "mocha";
  } // (lib.attrsets.genAttrs [
    "kitty"
    "bat"
    "zsh-syntax-highlighting"
    "cursors"
    "firefox"
    "fzf"
    "mpv"
    "nvim"
    "obs"
    "btop"
    "vesktop"
  ] (x: { enable = true; }));

  home = {
    shell.enableShellIntegration = true;
    shellAliases = {
      "nixos-update" = "sudo nixos-rebuild switch --flake /etc/nixos --impure";
      cd = "z";
      exa = "eza";
      ls = "eza";
      lr = "eza --sort modified";
      tree = "ls --tree";
      less = "less --RAW-CONTROL-CHARS";
      grep = "grep --color=auto";
      fgrep = "fgrep --color=auto";
      egrep = "egrep --color=auto";
      diff = "diff --color=auto";
      cp = "cp -i --one-file-system";
      rm = "rm -i --one-file-system";
      mv = "mv -i";
      sudo = "sudo ";
      gdiff = "git diff";
      glog = "git log";
      gadd = "git add";
      ginfo = "git info";
      grm = "git rm --cached";
      ca = "git commit";
      push = "git push";
      clone = "git clone";
    };
    packages = with pkgs; [
      # fonts
      (import ./cartograph-cf.nix args)
      liberation_ttf
      ubuntu-sans
      twitter-color-emoji
      fira-mono
      fira-code
      cantarell-fonts
      nerd-fonts.fira-code
      # command line tools
      file
      zip
      unzip
      less
      killall
      eza
      btop
      # desktop tools
      niri
      xwayland-satellite
      swayosd
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
      pavucontrol
      wl-clipboard
      libsForQt5.ksshaskpass
    ];
    sessionVariables = {
      # I don't see other places to set this
      EXA_COLORS =
        "ur=38;5;11:uw=38;5;9:ux=38;5;10:ue=38;5;10:gr=38;5;11:gw=38;5;9:gx=38;5;10:tr=38;5;11:tw=38;5;9:tx=38;5;10:su=38;5;13:sf=38;5;13:xa=38;5;13:sn=38;5;14:sb=38;5;6:df=38;5;11:ds=38;5;11:uu=38;5;14:un=38;5;15:gu=38;5;10:gn=38;5;15:lc=38;5;9:lm=38;5;13:ga=38;5;10:gm=38;5;14:gd=38;5;9:gv=38;5;11:gt=38;5;13:xx=38;5;8:da=38;5;14:in=38;5;13:bl=38;5;13:hd=38;5;15:lp=38;5;14:cc=48;5;15;38;5;0";
      NIXOS_OZONE_WL = "1";
      SUDO_ASKPASS = "ksshaskpass";
    };
  };

  programs = {
    vesktop = import ./vesktop.nix args;
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
    eza = {
      enable = true;
      colors = "auto";
      enableZshIntegration = true;
      icons = "auto";
      extraOptions = [ "--header" "--group" "--binary" "--sort=Name" ];
    };
    mpv.enable = true;
    obs-studio = {
      enable = true;
      plugins = [ pkgs.obs-studio-plugins.wlrobs ];
    };
    ripgrep.enable = true;
    git = {
      enable = true;
      lfs.enable = true;
      aliases = {
        sub = "submodule";
        subc = "submodule update --init --recursive";
        unstage = "restore --staged";
        r = "remote";
      };
      userEmail = "48314599+sophuric@users.noreply.github.com";
      userName = "sophur";
      signing = {
        key = "EAB0A643ABD82124552040FE39F3751CDD35BB5F";
        signByDefault = true;
      };
      extraConfig = {
        init.defaultBranch = "main";
        color.ui = "auto";
        format.pretty =
          "format:Commit %C(green)%H%C(auto)%(decorate)%C(default) %C(yellow)(%C(green)%G?%C(yellow))%nAuthor: %an %C(default)%C(dim)<%C(nodim)%C(default)%ae%C(default)%C(dim)> - %C(nodim)%ad%nCommit: %cn %C(default)<%ce%C(default)> - %cd%n%n%C(default)%C(dim)> %C(nodim)%C(magenta)%C(ul)%s%n%n%b%n%C(dim)---%C(nodim)%C(default)";
        url = { "https://github.com/" = { insteadOf = [ "gh:" "github:" ]; }; };
      };
    };

    bat = {
      config = {
        pager = "less --RAW-CONTROL-CHARS --quit-if-one-screen --quit-on-intr";
        decorations = "never";
      };
      enable = true;
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" ];
      };
      syntaxHighlighting = {
        enable = true;
        highlighters = [ "main" "brackets" ];
      };
      initContent = ''
        setopt HIST_FCNTL_LOCK RM_STAR_WAIT AUTO_PUSHD CHASE_DOTS CHASE_LINKS PUSHD_IGNORE_DUPS PUSHD_SILENT AUTO_LIST GLOB_DOTS
        bindkey '\C-h' backward-kill-word
      '';
      history = {
        size = 10000;
        save = 10000;
        ignoreDups = true;
        share = true;
        extended = true;
      };
      autocd = true;
    };

    dircolors = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        FILE = "38;5;15";
        BLOCK = "38;5;13";
        CHAR = "38;5;11";
        LINK = "38;5;14";
        PIPE = "38;5;11";
        SOCK = "38;5;11";
        DIR = "38;5;12";
        EXEC = "38;5;10";
        ORPHAN = "38;5;1";
        ".jar" = "38;5;208";
        ".lua" = "38;5;126";
        ".py" = "38;5;184";
      } // (lib.attrsets.genAttrs [
        ".z64"
        ".n64"
        ".nds"
        ".cia"
        ".nes"
        ".gb"
        ".gbc"
        ".gba"
        ".sgm"
        ".sav"
      ] (x: "38;5;48"));
    };

    zoxide.enable = true;
    zoxide.enableZshIntegration = true;

    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      withNodeJs = true;
    };

    ssh = {
      enable = true;
      addKeysToAgent = "yes";
      matchBlocks = {
        "*" = { serverAliveInterval = 240; };
        "github.com" = {
          identityFile = "~/.ssh/online_ed25519";
          user = "git";
        };
        "gist.github.com" = {
          identityFile = "~/.ssh/online_ed25519";
          user = "git";
        };
        "gitlab.com" = {
          identityFile = "~/.ssh/online_ed25519";
          user = "git";
        };
      };
    };

    zen-browser = {
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
    };

    keepassxc = {
      enable = true;
      settings = {
        General.BackupBeforeSave = true;
        Browser.Enabled = true;
        FdoSecrets = {
          Enabled = true;
          NoConfirmDeleteItem = false;
          UnlockBeforeSearch = true;
        };
        GUI = {
          ApplicationTheme = "classic";
          CheckForUpdates = false;
          ColorPasswords = true;
          CompactMode = true;
          HidePasswords = true;
          HidePreviewPanel = false;
          HideToolbar = false;
          HideUsernames = false;
          MinimizeOnClose = true;
          MinimizeOnStartup = true;
          MinimizeToTray = true;
          MonospaceNotes = true;
          MovableToolbar = false;
          ShowExpiredEntriesOnDatabaseUnlock = false;
          ShowTrayIcon = true;
          ToolButtonStyle = 0;
          TrayIconAppearance = "monochrome-light";
        };
        PasswordGenerator = import /root/keepassxc-password-generator;
        SSHAgent.Enabled = true;
        Security = {
          ClearClipboardTimeout = 7;
          IconDownloadFallback = true;
          LockDatabaseIdle = true;
          LockDatabaseIdleSeconds = 120;
          LockDatabaseMinimize = false;
          LockDatabaseScreenLock = true;
          NoConfirmMoveEntryToRecycleBin = false;
        };
      };
    };
    kitty = {
      enable = true;
      settings = {
        kitty_mod = "ctrl+shift";
        clear_all_shortcuts = true;
        confirm_os_window_close = 1;
        enable_audio_bell = false;
        tab_bar_edge = "top";
        tab_bar_style = "powerline";
        tab_bar_align = "left";
        tab_bar_min_tabs = 2;
        active_tab_foreground = "#11111b";
        active_tab_background = "#f5c2e7";
        active_tab_font_style = "bold";
        inactive_tab_foreground = "#f5c2e7";
        inactive_tab_background = "#181825";
        inactive_tab_font_style = "normal";
        selection_background = "#f5c2e7";
        paste_actions = "quote-urls-at-prompt,confirm,confirm-if-large";
        strip_trailing_spaces = "smart";
        remember_window_size = false;
        remember_window_position = false;
        hide_window_decorations = true;
        background_opacity = 0.75;
      };
      keybindings = {
        "kitty_mod+C" = "copy_to_clipboard";
        "kitty_mod+V" = "paste_from_clipboard";
        "kitty_mod+down" = "scroll_line_down";
        "kitty_mod+up" = "scroll_line_up";
        "kitty_mod+J" = "scroll_line_down";
        "kitty_mod+K" = "scroll_line_up";
        "kitty_mod+page_up" = "scroll_page_up";
        "kitty_mod+page_down" = "scroll_page_down";
        "kitty_mod+home" = "scroll_home";
        "kitty_mod+end" = "scroll_end";
        "kitty_mod+F" = "show_scrollback";
        "kitty_mod+G" =
          "launch --type=overlay --stdin-source=@screen_scrollback fzf --no-sort --tac --exact -i";
        "kitty_mod+W" = "close_window";
        "kitty_mod+]" = "next_window";
        "kitty_mod+[" = "previous_window";
        "ctrl+tab" = "next_tab";
        "ctrl+shift+tab" = "previous_tab";
        "kitty_mod+right" = "next_tab";
        "kitty_mod+left" = "previous_tab";
        "kitty_mod+t" = "new_tab";
        "kitty_mod+." = "move_tab_forward";
        "kitty_mod+," = "move_tab_backward";
        "ctrl+alt+tab" = "set_tab_title";
        "kitty_mod+equal" = "change_font_size all +2.0";
        "kitty_mod+minus" = "change_font_size all -2.0";
        "kitty_mod+0" = "change_font_size all 0";
        "kitty_mod+u" = "kitten unicode_input";
        "kitty_mod+f5" = "load_config_file";
        "kitty_mod+delete" = "clear_terminal reset active";
        "kitty_mod+enter" = "detach_window ask";
      };
    };
  };

  xdg = {
    configFile = {
      # TODO: migrate to niri-flake
      niri.source = ./niri;
    };
  };

  systemd.user.services = lib.attrsets.mapAttrs (name: value:
    {
      # serviceConfig.PassEnvironment =
      # lib.strings.concatStringsSep " " [ "DISPLAY" "WAYLAND_DISPLAY" "" ];
      Service.ExecStart = value.binary;
      Unit.PartOf = [ "graphical-session.target" ];
      Install.WantedBy = [ "graphical-session.target" ]; # start after login
    } // value) {
      swayosd = { Service.ExecStart = "${pkgs.swayosd}/bin/swayosd-server"; };
      keepassxc = { Service.ExecStart = "${pkgs.keepassxc}/bin/keepassxc"; };
    };

  home.stateVersion = "25.05"; # Do not change
}
