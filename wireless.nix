# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
{ ... }:

{
  networking.wireless = {
    scanOnLowSignal = true;
    fallbackToWPA2 = false;
    enable = true;
    userControlled.enable = true;
  };
}
