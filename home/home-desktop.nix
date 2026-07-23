# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
args@{
  config,
  util,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./home-headless.nix
    ./kitty.nix
    ./waybar.nix
    ./mime.nix
    ./screenshot-scripts.nix
    ./lock.nix
  ];

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      serif = [ "Liberation Serif" ];
      sansSerif = [ "Ubuntu Sans" ];
      monospace = [
        "Cartograph CF"
        "Fira Code"
        "FiraCode Nerd Font Mono"
        "Fira Mono"
      ];
      emoji = [ "Twitter Color Emoji" ];
    };
  };

  catppuccin = lib.attrsets.genAttrs [ "cursors" "mpv" "obs" "fuzzel" "mako" ] (_: {
    enable = true;
  });

  qt = {
    platformTheme.name = "kvantum";
    style.name = "kvantum";
    enable = true;
  };

  home = {
    packages =
      with pkgs;
      [
        # fonts
        (import ./cartograph-cf.nix args)
        liberation_ttf
        ubuntu-sans
        twitter-color-emoji
        fira-mono
        fira-code
        nerd-fonts.fira-code
        # desktop tools
        niri
        xwayland-satellite
        egl-wayland
        glfw
        swayosd
        pavucontrol
        kdePackages.ksshaskpass
        gimp
        qpdfview
        nemo
        libnotify
        dconf
        songrec
        playerctl
        signal-desktop
        nemo-fileroller
        file-roller
        qdirstat
        dragon-drop
        (pkgs.writeShellApplication {
          name = "emoji-picker";
          runtimeInputs = [
            pkgs.wl-clipboard
            pkgs.fuzzel
            pkgs.libnotify
          ];
          text = ''
            OUT="$(fuzzel --match-mode=fuzzy --dmenu --prompt 'Select Emoji > ' < ${
              pkgs.fetchurl {
                url = "https://github.com/sophuric/emojipicker/raw/7cc87962da618285ac102a8908243e662f180788/emojis";
                hash = "sha256-wy7IcZ5ikT6xr8je46vG3P0Os9S4r2Hn2/abJpfrkrg=";
              }
            })"
            test -n "$OUT"
            EMOJI="$(cut -d' ' -f1 <<< "$OUT")"
            DESC="$(cut -d' ' -f2- <<< "$OUT")"
            notify-send -- "Copied Emoji: $EMOJI" "$DESC"
            printf "%s" "$EMOJI" | wl-copy
          '';
        })
        (pkgs.writeShellApplication {
          name = "toggle-swayidle";
          runtimeInputs = [
            pkgs.swayidle
            pkgs.libnotify
          ];
          text = ''
            if systemctl --user is-active --quiet swayidle.service; then
              systemctl --user stop swayidle.service
              notify-send -- "Disabled auto-lock"
            else
              systemctl --user start swayidle.service
              notify-send -- "Enabled auto-lock"
            fi
          '';
        })
        hunspell
      ]
      ++ (
        let
          cfg = import (args.self + /local.nix); # This is hacky
        in
        (builtins.map (x: pkgs.hunspellDicts.${builtins.substring 0 (util.firstIndexOf x ".") x}) (
          [ cfg.i18n.defaultLocale ] ++ cfg.i18n.extraLocales
        ))
      )
      ++ config.xdg.portal.extraPortals;

    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      SUDO_ASKPASS = "ksshaskpass";
    };

    pointerCursor = {
      enable = true;
      dotIcons.enable = true;
      gtk.enable = true;
      size = 32;
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
    ];
    config.niri = {
      "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
      "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
    };
  };

  gtk = {
    enable = true;
    font = {
      name = util.first config.fonts.fontconfig.defaultFonts.sansSerif;
      size = 12;
    };
    theme =
      let
        size = "standard";
        shade = if config.catppuccin.flavor == "latte" then "light" else "dark";
      in
      with config.catppuccin;
      {
        # The official Catppuccin GTK port is deprecated, so I'm using another GTK theme
        name = "Catppuccin-GTK-${lib.toSentenceCase accent}-${lib.toSentenceCase shade}";
        package = pkgs.magnetic-catppuccin-gtk.override {
          inherit shade;
          inherit size;
          accent = [ accent ];
          tweaks = (if (flavor == "frappe" || flavor == "macchiato") then [ flavor ] else [ ]) ++ [
            "outline"
          ];
        };
      };
    gtk4.theme = config.gtk.theme;
    gtk3.theme = config.gtk.theme;
  };

  programs = {
    feh.enable = true;

    mpv = {
      enable = true;
      scripts = with pkgs.mpvScripts; [
        mpris
        sponsorblock
      ];
      config = {
        screenshot-dir = "~/screenshots/";
        vo = "gpu";
        hwdec = "auto";
        profile = "gpu-hq";
        gpu-context = "wayland";
        script-opts = "osc-timems=yes";
        keep-open = true;
        audio-display = false;
        prefetch-playlist = true;
        save-position-on-quit = true;
        resume-playback = true;
      };
    };

    obs-studio = {
      enable = true;
      plugins = [ pkgs.obs-studio-plugins.wlrobs ];
    };

    fuzzel = {
      enable = true;
      settings = {
        main = {
          font = "sans-serif:size=16";
          line-height = 36;
          match-mode = "fzf";
        };
        border = {
          width = 4;
          radius = 40;
        };
      };
    };
  };

  xdg.configFile = {
    niri.source = ./niri;
  };

  services = {
    mako = {
      enable = true;
      settings = {
        anchor = "bottom-right";
        output = "DP-1";
        border-radius = 12;
        font = "sans-serif 12";
        icons = true;
        margin = 16;
        outer-margin = 24;
        padding = 8;
        default-timeout = 10000;
        on-button-left = "invoke-default-action";
        on-button-middle = "none";
        on-button-right = "dismiss";
        on-touch = "dismiss";
        on-notify = "none";
      };
    };

    udiskie = {
      automount = false;
      enable = true;
      notify = true;
      tray = "always";
    };

    blueman-applet.enable = true;

    gpg-agent.pinentry.package = lib.mkIf config.services.gpg-agent.enable pkgs.pinentry-qt;
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };

  systemd.user.services =
    lib.attrsets.mapAttrs
      (
        name:
        value@{ package, bin }:
        util.merge [
          # https://github.com/spikespaz/dotfiles/blob/odyssey/hm-modules/keepassxc.nix
          {
            Unit = {
              Description = package.meta.description;
              After = [ "graphical-session.target" ];
            };
            Service = {
              Type = "simple";
              KillMode = "process";
              ExecStart = lib.getExe' package bin;
              Restart = "on-failure";
              RestartSec = 5;
            };
            Install = {
              WantedBy = [ "graphical-session.target" ];
            };
          }
          (removeAttrs value [
            "package"
            "bin"
          ])
        ]
      )
      {
        swayosd = {
          package = pkgs.swayosd;
          bin = "swayosd-server";
        };
        keepassxc = {
          package = pkgs.keepassxc;
          bin = "keepassxc";
        };
      };
}
