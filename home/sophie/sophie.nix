# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
args@{ config, util, lib, pkgs, ... }: {
  imports = [
    args.zen-browser.homeModules.twilight
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
    }
    (lib.attrsets.genAttrs [ "cursors" "mpv" "obs" "swaylock" "fuzzel" ]
      (_: { enable = true; }))
  ];

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
      wl-clipboard
      libsForQt5.ksshaskpass
      gimp
      prismlauncher
      qpdfview
    ];
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      SUDO_ASKPASS = "ksshaskpass";
    };

    pointerCursor = {
      enable = true;
      dotIcons.enable = true;
      size = 32;
    };
  };

  programs = {
    mpv.enable = true;

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
    udiskie = {
      automount = false;
      enable = true;
      notify = true;
      tray = "always";
    };
    blueman-applet.enable = true;
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
