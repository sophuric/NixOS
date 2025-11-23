# vim: fixeol eol expandtab tabstop=2 shiftwidth=2

args@{ self, util, pkgs, lib, config, ... }: {
  imports = [
    args.catppuccin.nixosModules.catppuccin
    args.home-manager.nixosModules.home-manager
    ./hardware-configuration.nix
  ] ++ builtins.map (x: self + /${x}) ([ "local.nix" "networking.nix" ]
    ++ (builtins.map (x: "options/${x}") [
      "base.nix"
      "limine.nix"
      "nvidia.nix"
      "virtualisation.nix"
      "bluetooth.nix"
      "printing.nix"
      "webdav.nix"
      "audio.nix"
      "openssh.nix"
      "greeter.nix"
      "steam.nix"
    ]));

  config = {
    swapDevices = [{ device = "/swap/swapfile"; }];

    hardware.graphics.enable = true;

    security.pam.services.swaylock = { };

    services.udisks2.enable = true;
    services.gvfs.enable = true;

    services.tailscale.enable = true;

    programs.localsend.enable = true;

    users.users.sophie = {
      isNormalUser = true;
      extraGroups = [ "wheel" "ssh" "libvirtd" ];
    };
  };
}
