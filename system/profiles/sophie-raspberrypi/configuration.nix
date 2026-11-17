# vim: fixeol eol expandtab tabstop=2 shiftwidth=2

{
  nixos-hardware,
  inputs,
  pkgs,
  username,
  ...
}:
{
  imports = [
    nixos-hardware.nixosModules.raspberry-pi-4
    ./hardware-configuration.nix
  ]
  ++ map (x: inputs.self + /system/${x}) (
    [
      /local.nix
      /networking.nix
    ]
    ++ (map (x: /modules/${x}) [
      /base.nix
      /openssh.nix
    ])
  );

  config = {
    # swapDevices = [{ device = "/swap/swapfile"; }];

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

    boot.loader.limine.efiSupport = true;

    boot.kernelParams = [ "fbcon=rotate:1" ];

    users.users.${username}.extraGroups = [
      "wheel"
      "ssh"
    ];
  };
}
