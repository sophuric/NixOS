# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
{ config, ... }: {
  # https://wiki.nixos.org/wiki/OBS_Studio#Using_the_Virtual_Camera
  boot = {
    kernelModules = [ "v4l2loopback" ];
    extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];

    extraModprobeConfig = ''
      options v4l2loopback devices=1 video_nr=1 card_label="Camera" exclusive_caps=1
    '';
  };
}
