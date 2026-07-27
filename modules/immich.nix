# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
{
  pkgs,
  lib,
  config,
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
    # wrapper to set host to tailscale
    package =
      (pkgs.writeShellApplication {
        name = "immich-wrapper";
        runtimeInputs = with pkgs; [
          immich
          tailscale
        ];
        text = ''
          IMMICH_HOST="$(tailscale ip -4 | head -n1)" exec server "$@"
        '';
      })
      // {
        machine-learning = pkgs.immich.machine-learning;
      };
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
