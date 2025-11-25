# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
{ catppuccin, config, pkgs, lib, ... }: {
  imports = [ catppuccin.nixosModules.catppuccin ];

  options = {
    allowUnfreePackages = lib.mkOption {
      type = lib.types.listOf lib.types.anything;
      default = [ ];
      description =
        "List of package names as a string, or predicates that accept a package name as a string";
      # This allows mkMerge to work with this
    };
  };

  config = {
    networking.firewall.enable = true;

    nixpkgs.config.allowUnfreePredicate = (pkg:
      builtins.any
      (x: (if builtins.isFunction x then (x pkg) else (x == (lib.getName pkg))))
      config.allowUnfreePackages);

    boot.blacklistedKernelModules = [ "pcspkr" ];

    catppuccin = {
      accent = "pink";
      flavor = "mocha";
      tty.enable = true;
    };

    console = {
      earlySetup = true;
      font = "${pkgs.terminus_font}/share/consolefonts/ter-v22n.psf.gz";
    };

    documentation.dev.enable = true;
    documentation.man = {
      man-db.enable = false;
      mandoc.enable = true;
    };

    security.sudo.extraConfig = "Defaults pwfeedback";

    services = {
      libinput.enable = true;
      gpm.enable = true;
    };

    users.defaultUserShell = pkgs.zsh;
    programs.zsh.enable = true;
    environment.shells = [ pkgs.zsh ];

    programs = {
      neovim.enable = true;
      neovim.defaultEditor = true;
    };

    environment.systemPackages = with pkgs; [
      man-pages
      man-pages-posix
      wget
      home-manager
      vlock
      pinentry-tty
      pciutils
      trash-cli
    ];

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    system.stateVersion = "25.05"; # Do not change
  };
}
