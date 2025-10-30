# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
{ trimNewlines, self, config, pkgs, ... }:

{
  networking.wireless = {
    scanOnLowSignal = true;
    fallbackToWPA2 = false;
    enable = true;
    # File should be simple key=value file, psk1=..., etc.
    # Use wpa_passphrase to generate passphrase
    secretsFile = "/root/wifi/secret";
    networks = {
      # I don't care about securing these SSIDs client-side, just from Git
      ${trimNewlines (builtins.readFile "/root/wifi/ssid1")}.pskRaw =
        "ext:psk1";
      ${trimNewlines (builtins.readFile "/root/wifi/ssid2")}.pskRaw =
        "ext:psk2";
    };
  };
}
