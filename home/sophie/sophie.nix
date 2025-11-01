# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
args@{ util, lib, pkgs, ... }:
let
  defaultFonts = {
    serif = [ "Liberation Serif" ];
    sansSerif = [ "Ubuntu Sans" "Cantarell" "FreeSans" ];
    monospace =
      [ "Cartograph CF" "Fira Code" "FiraCode Nerd Font Mono" "Fira Mono" ];
    emoji = [ "Twitter Color Emoji" ];
  };
in {
  imports = [
    args.zen-browser.homeModules.twilight
    ./nvim.nix
    ./shell.nix
    ./vesktop.nix
    ./zen-browser.nix
    ./keepassxc.nix
    ./kitty.nix
    ./syncthing.nix
  ];

  manual.html.enable = true;
  manual.manpages.enable = true;

  fonts.fontconfig = {
    enable = true;
    inherit defaultFonts;
  };

  catppuccin = util.merge [
    {
      accent = "pink";
      flavor = "mocha";
    }
    (lib.attrsets.genAttrs [ "cursors" "mpv" "nvim" "obs" ]
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
      cantarell-fonts
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
  };

  xdg = {
    configFile = {
      # TODO: migrate to niri-flake
      niri.source = ./niri;
    };
  };

  services = {
    udiskie = {
      automount = false;
      enable = true;
      notify = true;
      tray = "always";
    };
  };

  systemd.user.services = lib.attrsets.mapAttrs (name: value:
    util.merge [
      {
        Unit.PartOf = [ "graphical-session.target" ];
        Install.WantedBy = [ "graphical-session.target" ]; # start after login
      }
      value
    ]) {
      swayosd = { Service.ExecStart = "${pkgs.swayosd}/bin/swayosd-server"; };
      keepassxc = { Service.ExecStart = "${pkgs.keepassxc}/bin/keepassxc"; };
    };

  home.stateVersion = "25.05"; # Do not change
}
