# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
{ ... }:

let
  # Use wpa_passphrase to generate passphrase
  # Place result in networksFile, replace passphrase in networksFile with "ext:psk1"
  # Put passphrase in secretsFile as "psk1=passphrase_here"
  networksFile = /etc/wpa_supplicant/networks.conf;
  secretsFile = /etc/wpa_supplicant/secrets;
in
{
  networking.wireless = {
    scanOnLowSignal = true;
    fallbackToWPA2 = false;
    enable = true;
    userControlled = true; # Add user to wpa_supplicant group to use wpa_cli
    secretsFile = toString secretsFile;
    # Hide SSIDs publicly
    extraConfigFiles = [ (toString networksFile) ];
  };
  systemd.tmpfiles.rules = map (x: "f ${toString x} 0600 wpa_supplicant wpa_supplicant") [
    networksFile
    secretsFile
  ];
}
