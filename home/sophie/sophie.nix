# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
args@{ util, lib, pkgs, ... }: {
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
    (lib.attrsets.genAttrs [ "cursors" "mpv" "obs" "swaylock" ]
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
      settings = {
        font-size = 24;
        show-keyboard-layout = true;
        indicator-idle-visible = false;
        indicator-radius = 100;
        indicator-thickness = 16;
        scaling = "solid_color";
        show-failed-attempts = true;
        # override default catppuccin colours
        ring-color = lib.mkForce "313244";
        bs-hl-color = lib.mkForce "f38ba8";
        caps-lock-key-hl-color = lib.mkForce "f9e2af";
        caps-lock-bs-hl-color = lib.mkForce "fab387";
        key-hl-color = lib.mkForce "f5c2e7";
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
