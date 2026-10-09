# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  services.immich = {
    enable = true;
    port = 2283;
    user = "immich";
    accelerationDevices = [ "/dev/dri/renderD128" ];
    openFirewall = true;
    machine-learning.enable = true;
    package = inputs.immich-nixpkgs.legacyPackages.${pkgs.system}.immich;
  };
  systemd.services.immich-server = {
    requires = [ "tailscaled.service" ];
    after = [ "tailscaled.service" ];
  };
  users.users.immich.extraGroups = [
    "video"
    "render"
  ];
}
