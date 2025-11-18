# vim: fixeol eol expandtab tabstop=2 shiftwidth=2

# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

args@{ pkgs, lib, config, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./limine.nix
    ./local.nix
    ./networking.nix
    ./nvidia.nix
  ];

  options = {
    allowUnfreePackages = lib.mkOption {
      type = lib.types.listOf lib.types.anything;
      default = [ ];
      description =
        "List of package names as a string, or predicates that accept a package name as a string";
    };
  };

  config = {
    nixpkgs.config.allowUnfreePredicate = (pkg:
      builtins.any
      (x: (if builtins.isFunction x then (x pkg) else (x == (lib.getName pkg))))
      config.allowUnfreePackages);

    catppuccin = {
      accent = "pink";
      flavor = "mocha";
      tty.enable = true;
      limine.enable = true;
    };

    swapDevices = [{ device = "/swap/swapfile"; }];

    hardware.graphics = { enable = true; };

    hardware.bluetooth = {
      # https://nixos.wiki/wiki/Bluetooth
      enable = true;
      powerOnBoot = true;
      settings = {
        General.Experimental = true; # Battery charge
        Policy.AutoEnable = true;
      };
    };

    boot.blacklistedKernelModules = [ "pcspkr" ];

    documentation.dev.enable = true;
    documentation.man = {
      man-db.enable = false;
      mandoc.enable = true;
    };

    security.sudo.extraConfig = "Defaults pwfeedback";

    security.pam.services.swaylock = { };

    console = {
      earlySetup = true;
      font = "${pkgs.terminus_font}/share/consolefonts/ter-v22n.psf.gz";
      keyMap = "us";
    };

    services = {
      blueman.enable = true;

      printing.enable = true;

      avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };

      pipewire = {
        enable = true;
        pulse.enable = true;
      };

      libinput.enable = true;
      gpm.enable = true;

      udisks2.enable = true;

      tailscale.enable = true;

      webdav = {
        enable = true;
        environmentFile = "/root/webdav.env";
        settings = {
          address = "localhost";
          port = 57259;
          users = [{
            username = "sophie";
            password = "{env}SOPHIE_PASS";
            directory = "${config.users.users.sophie.home}/.webdav";
            permissions = "CRUD";
          }];
        };
      };
    };

    systemd.user.tmpfiles.users.sophie.rules = [
      "a %h - - - - u:webdav:r-x" # allow webdav to read home dir
      "A %h/.webdav - - - - u:webdav:rwx" # allow webdav to read/modify ~/.webdav
    ];

    environment = {
      # List packages installed in system profile.
      # You can use https://search.nixos.org/ to find more packages (and options).
      systemPackages = with pkgs; [
        man-pages
        man-pages-posix
        wget
        home-manager
        vlock
        gnupg
        pinentry-tty
        pciutils
        trash-cli
      ];
      shells = with pkgs; [ zsh ];
    };

    home-manager.backupFileExtension = "backup";

    users.defaultUserShell = pkgs.zsh;

    allowUnfreePackages =
      [ "steam" "steam-original" "steam-unwrapped" "steam-run" ];

    programs = {
      localsend.enable = true;

      virt-manager.enable = true;

      neovim.enable = true;
      neovim.defaultEditor = true;

      zsh.enable = true;

      gnupg.agent.pinentryPackage = pkgs.pinentry-tty;
      gnupg.agent.enable = true;
      gnupg.agent.enableSSHSupport = true;

      steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
      };

      # Some programs need SUID wrappers, can be configured further or are
      # started in user sessions.
    };

    services = {
      gvfs.enable = true;

      openssh = {
        enable = true;
        ports = [ 13519 ];
        settings = {
          KbdInteractiveAuthentication = false;
          PasswordAuthentication = false;
          PubkeyAuthentication = true;
          PermitRootLogin = "no";
          X11Forwarding = false;
          GatewayPorts = "no";
          AllowGroups = [ "ssh" ];
          UseDns = false;
        };
        allowSFTP = true;
      };

      greetd = {
        vt = 7;
        enable = true;
        settings = {
          default_session.command =
            "${pkgs.greetd.tuigreet}/bin/tuigreet -t --time-format '%F %H:%M:%S' --remember --remember-user-session --user-menu --asterisks --asterisks-char '◆' --window-padding 2";
        };
      };
    };

    users.groups = {
      ssh = { };
      libvirtd = { };
    };

    users.users.sophie = {
      isNormalUser = true;
      extraGroups = [ "wheel" "ssh" "libvirtd" ];
    };

    virtualisation.libvirtd.enable = true;
    virtualisation.spiceUSBRedirection.enable = true;
    services.qemuGuest.enable = true;
    services.spice-vdagentd.enable = true;

    networking.firewall.allowedTCPPorts = [ ];
    networking.firewall.allowedUDPPorts = [ ];

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    # This option defines the first version of NixOS you have installed on this particular machine,
    # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
    #
    # Most users should NEVER change this value after the initial install, for any reason,
    # even if you've upgraded your system to a new NixOS release.
    #
    # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
    # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
    # to actually do that.
    #
    # This value being lower than the current NixOS release does NOT mean your system is
    # out of date, out of support, or vulnerable.
    #
    # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
    # and migrated your data accordingly.
    #
    # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
    system.stateVersion = "25.05"; # Did you read the comment?
  };
}
