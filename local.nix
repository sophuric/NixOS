# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
{ self, config, pkgs, ... }:

{
  time.timeZone = "Australia/Melbourne";
  i18n.defaultLocale = "en_AU.UTF-8";
  i18n.defaultCharset = "UTF-8";
  i18n.extraLocales = [ "en_US.UTF-8/UTF-8" ];
}
