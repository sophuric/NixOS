# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
{ ... }:

{
  networking.wireless = {
    scanOnLowSignal = true;
    fallbackToWPA2 = false;
    enable = true;
    userControlled = true;
    # File should be simple key=value file, psk1=..., etc.
    # Use wpa_passphrase to generate passphrase
    secretsFile = "/var/wifi-secret";
    # Hide SSIDs publicly
    networks = import /root/wifi-networks.nix;
  };
  systemd.tmpfiles.rules = [
    "f /var/wifi-secret 0600 wpa_supplicant wpa_supplicant" # make sure wifi-secret can be read by wpa_supplicant
  ];
}
