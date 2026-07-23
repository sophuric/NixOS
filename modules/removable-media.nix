# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
{ ... }: {
  services.udisks2.enable = true;

  systemd.tmpfiles.rules = [
    "L /media - - - - run/media" # quick access to /run/media
  ];
}
