# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
{ ... }: {
  hardware.bluetooth = {
    # https://nixos.wiki/wiki/Bluetooth
    enable = true;
    powerOnBoot = true;
    settings = {
      General.Experimental = true; # Battery charge
      Policy.AutoEnable = true;
    };
  };
  services.blueman.enable = true;
}
