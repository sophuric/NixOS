# vim: fixeol eol expandtab tabstop=2 shiftwidth=2

args@{ self, util, pkgs, lib, config, ... }: {
  imports = [ ./hardware-configuration.nix ] ++ builtins.map (x: self + /${x})
    ([ /local.nix /networking.nix ] ++ (builtins.map (x: /modules/${x}) [
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
    ]));

  config = {
    swapDevices = [{ device = "/swap/swapfile"; }];

    hardware.graphics.enable = true;

    security.pam.services.swaylock = { };

    services.gvfs.enable = true;

    services.tailscale.enable = true;

    programs.localsend.enable = true;

    home-manager.users.sophie.imports = [ (self + /home/profiles/sophie-desktop.nix) ];

    users.users.sophie = {
      uid = 1000;
      isNormalUser = true;
      extraGroups = [ "wheel" "ssh" "libvirtd" "docker" ];
    };

    networking.firewall.allowedTCPPorts = [ 25565 8123 53317 ];

    boot.kernelPackages = pkgs.linuxPackages_latest;
  };
}
