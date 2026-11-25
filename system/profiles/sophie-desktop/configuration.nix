# vim: fixeol eol expandtab tabstop=2 shiftwidth=2

{
  pkgs,
  inputs,
  username,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ]
  ++ map (x: inputs.self + /system/${x}) (
    [
      /local.nix
      /networking.nix
    ]
    ++ (map (x: /modules/${x}) [
      /base.nix
      /limine.nix
      /nvidia.nix
      /virtualisation.nix
      /bluetooth.nix
      /printing.nix
      /audio.nix
      /openssh.nix
      /greeter.nix
      /steam.nix
      /removable-media.nix
      /obs-virtual-camera.nix
      /immich.nix
      /docker.nix
    ])
  );

  config = {
    swapDevices = [ { device = "/swap/swapfile"; } ];

    hardware.graphics.enable = true;

    security.pam.services.swaylock = { };

    services.gvfs.enable = true;

    programs.localsend.enable = true;

    users.users.${username}.extraGroups = [
      "wheel"
      "ssh"
      "libvirtd"
      "docker"
    ];

    networking.firewall.allowedTCPPorts = [
      33280
      33281
      33282
      33283
    ];

    boot.loader.limine.efiSupport = true;

    boot.kernelPackages = pkgs.linuxPackages_latest;
  };
}
