# vim: fixeol eol expandtab tabstop=2 shiftwidth=2

args@{ self, util, pkgs, lib, config, ... }: {
  imports = [
    args.nixos-hardware.nixosModules.raspberry-pi-4
    ./hardware-configuration.nix
  ] ++ builtins.map (x: self + /${x}) ([ "local.nix" "networking.nix" ]
    ++ (builtins.map (x: "options/${x}") [
      "base.nix"
      # "limine.nix"
      # "nvidia.nix"
      # "virtualisation.nix"
      # "bluetooth.nix"
      # "printing.nix"
      # "webdav.nix"
      # "audio.nix"
      "openssh.nix"
      # "greeter.nix"
      # "steam.nix"
      # "removable-media.nix"
    ]));

  config = {
    # swapDevices = [{ device = "/swap/swapfile"; }];

    services.tailscale.enable = true;

    hardware = {
      raspberry-pi."4".apply-overlays-dtmerge.enable = true;
      deviceTree = {
        enable = true;
        filter = "*rpi-4-*.dtb";
      };
    };

    boot.initrd.luks.devices.cryptroot.device =
      "/dev/disk/by-uuid/3e8324f4-4c12-4f4f-a0e0-a96b8e3b831d";

    environment.systemPackages = with pkgs; [
      libraspberrypi
      raspberrypi-eeprom
    ];

    boot.kernelParams = [ "fbcon=rotate:1" ];

    home-manager.users.sophie.imports =
      [ (self + /home/profiles/raspberrypi.nix) ];

    users.users.sophie = {
      uid = 1000;
      isNormalUser = true;
      extraGroups = [ "wheel" "ssh" ];
    };
  };
}
