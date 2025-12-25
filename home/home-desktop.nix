# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
args@{ config, util, lib, pkgs, ... }: {
  imports = [ ./home-headless.nix ./kitty.nix ./waybar.nix ./mime.nix ];

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      serif = [ "Liberation Serif" ];
      sansSerif = [ "Ubuntu Sans" ];
      monospace =
        [ "Cartograph CF" "Fira Code" "FiraCode Nerd Font Mono" "Fira Mono" ];
      emoji = [ "Twitter Color Emoji" ];
    };
  };

  catppuccin =
    lib.attrsets.genAttrs [ "cursors" "mpv" "obs" "swaylock" "fuzzel" "mako" ]
    (_: { enable = true; });

  qt = {
    platformTheme.name = "kvantum";
    style.name = "kvantum";
    enable = true;
  };

  home = {
    packages = with pkgs; [
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
      swayosd
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
      pavucontrol
      kdePackages.ksshaskpass
      gimp
      (prismlauncher.override { jdks = [ jdk8 jdk17 jdk21 jdk25 ]; })
      qpdfview
      nemo
      libnotify
      dconf
      songrec
      playerctl
      signal-desktop
      (pkgs.writeShellApplication {
        name = "emoji-picker";
        runtimeInputs = [ pkgs.wl-clipboard pkgs.fuzzel pkgs.libnotify ];
        text = ''
          OUT="$(fuzzel --match-mode=fuzzy --dmenu --prompt 'Select Emoji > ' < ${
            pkgs.fetchurl {
              url =
                "https://github.com/sophuric/emojipicker/raw/7cc87962da618285ac102a8908243e662f180788/emojis";
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
        name = "get-last-screenshot.sh";
        text =
          "find ~/screenshots -type f -printf '%T@ %p\\n' | sort --numeric-sort --reverse | cut -d' ' -f2- | head -1";
      })
      (pkgs.writeShellApplication {
        name = "open-last-screenshot.sh";
        runtimeInputs = [ pkgs.feh ];
        text = ''feh --class=feh-float - < "$(get-last-screenshot.sh)"'';
      })
      (pkgs.writeShellApplication {
        name = "copy-last-screenshot.sh";
        runtimeInputs = [ pkgs.wl-clipboard ];
        text = ''wl-copy < "$(get-last-screenshot.sh)"'';
      })
      (pkgs.writeShellApplication {
        name = "scan-last-screenshot.sh";
        runtimeInputs =
          [ pkgs.zbar pkgs.neovim pkgs.libnotify pkgs.wl-clipboard pkgs.kitty ];
        text = ''
          TMP="$(mktemp)"
          zbarimg --quiet --raw - < "$(get-last-screenshot.sh)" > "$TMP" || {
            [[ "$?" == "4" ]] && {
              notify-send "No barcodes were detected"
              rm -- "$TMP"
              false
            }
          }
          wl-copy -t text/plain < "$TMP"
          if [[ -n "$(notify-send --action default=Open -- "$(<"$TMP")" "Decoded data copied to clipboard - Click to open in neovim")" ]]; then kitty -- nvim -MR -- "$TMP"; fi
          rm -- "$TMP"
        '';
      })
    ];
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

  gtk = {
    enable = true;
    font.name = util.first config.fonts.fontconfig.defaultFonts.sansSerif;
    font.size = 12;
    theme = let size = "standard";
    in with config.catppuccin; {
      # https://www.reddit.com/r/NixOS/comments/1dlqoem/comment/l9qr2hw/
      name = "catppuccin-${flavor}-${accent}-${size}";
      # Catppuccin Nix is deprecated but there's no other choice
      package = pkgs.catppuccin-gtk.override {
        accents = [ accent ];
        variant = flavor;
        inherit size;
      };
    };
  };

  programs = {
    feh.enable = true;

    mpv = {
      enable = true;
      scripts = with pkgs.mpvScripts; [ mpris sponsorblock ];
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

    swaylock = {
      enable = true;
      settings = let palette = util.getPalette config;
      in {
        font-size = 24;
        show-keyboard-layout = true;
        indicator-idle-visible = false;
        indicator-radius = 100;
        indicator-thickness = 16;
        scaling = "solid_color";
        show-failed-attempts = true;
        # override default catppuccin colours
        ring-color = lib.mkForce palette.surface0.hex;
        bs-hl-color = lib.mkForce palette.red.hex;
        caps-lock-key-hl-color = lib.mkForce palette.yellow.hex;
        caps-lock-bs-hl-color = lib.mkForce palette.peach.hex;
        key-hl-color = lib.mkForce palette.pink.hex;
      };
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

  xdg.configFile = { niri.source = ./niri; };

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

    swayidle = let lock = "${lib.getExe' pkgs.swaylock "swaylock"} --daemonize";
    in {
      enable = true;
      events = [
        {
          event = "lock";
          command = lock;
        }
        {
          event = "before-sleep";
          command = lock;
        }
      ];
      timeouts = [{
        timeout = 60;
        command = lock;
      }];
    };

    blueman-applet.enable = true;

    gpg-agent.pinentry.package =
      lib.mkIf config.services.gpg-agent.enable pkgs.pinentry-qt;
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };

  systemd.user.services = lib.attrsets.mapAttrs (name:
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
        Install = { WantedBy = [ "graphical-session.target" ]; };
      }
      (removeAttrs value [ "package" "bin" ])
    ]) {
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
