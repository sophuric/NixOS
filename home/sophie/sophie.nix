# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
args@{ config, util, lib, pkgs, ... }: {
  imports = [
    ./nvim.nix
    ./shell.nix
    ./vesktop.nix
    ./zen-browser.nix
    ./keepassxc.nix
    ./kitty.nix
    ./syncthing.nix
    ./waybar.nix
  ];

  manual.html.enable = true;
  manual.manpages.enable = true;

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

  catppuccin = util.merge [
    {
      accent = "pink";
      flavor = "mocha";
      kvantum = {
        apply = true;
        enable = true;
      };
    }
    (lib.attrsets.genAttrs [ "cursors" "mpv" "obs" "swaylock" "fuzzel" "mako" ]
      (_: { enable = true; }))
  ];

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
      libsForQt5.ksshaskpass
      gimp
      prismlauncher
      qpdfview
      nemo
      libnotify
      dconf
      songrec
      localsend
      playerctl
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

    preferXdgDirectories = true;
  };

  gtk = {
    enable = true;
    font.name = util.first config.fonts.fontconfig.defaultFonts.sansSerif;
    font.size = 12;
  };

  programs = {
    feh.enable = true;

    mpv = {
      enable = true;
      config = {
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

    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      withNodeJs = true;
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

  xdg = { configFile = { niri.source = ./niri; }; };

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

  home.stateVersion = "25.05"; # Do not change
}
