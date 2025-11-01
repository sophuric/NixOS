# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
{ util, self, config, pkgs, ... }:

{
  networking.wireless = {
    scanOnLowSignal = true;
    fallbackToWPA2 = false;
    enable = true;
    # File should be simple key=value file, psk1=..., etc.
    # Use wpa_passphrase to generate passphrase
    secretsFile = "/root/wifi/secret";
    # I don't care about securing these SSIDs client-side, just from Git
    networks = import /root/wifi-networks.nix;
  };
}
