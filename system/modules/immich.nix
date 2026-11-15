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
    package = inputs.immich-nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system}.immich;
  };
  users.users.immich.extraGroups = [
    "video"
    "render"
  ];
}
