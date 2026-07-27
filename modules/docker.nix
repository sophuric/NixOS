# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
{
  config,
  pkgs,
  util,
  ...
}:
{
  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
  };
}
