# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
{ ... }: {
  services = {
    printing.enable = true;

    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };
}
