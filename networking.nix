# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
{ ... }:

let
  hostName = "sophie";
  nextdnsProfile = "24d2dd";
in {
  imports = [ ./wireless.nix ];

  networking = {
    hostName = hostName;

    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    nameservers = [ "127.0.0.1" "::1" ];

    # disable getting DNS from DHCP
    dhcpcd.extraConfig = "nohook resolv.conf";
    networkmanager.dns = "none";
  };

  services.unbound = {
    enable = true;
    settings = {
      server = {
        # When only using Unbound as DNS, make sure to replace 127.0.0.1 with your ip address
        # When using Unbound in combination with pi-hole or Adguard, leave 127.0.0.1, and point Adguard to 127.0.0.1:PORT
        interface = [ "127.0.0.1" ];
        port = 53;
        access-control = [ "127.0.0.1 allow" ];
        # Based on recommended settings in https://docs.pi-hole.net/guides/dns/unbound/#configure-unbound
        harden-glue = true;
        harden-dnssec-stripped = true;
        use-caps-for-id = false;
        prefetch = true;
        edns-buffer-size = 1232;

        # Custom settings
        hide-identity = true;
        hide-version = true;
      };
      remote-control = {
        control-enable = true;
        control-interface = [ "127.0.0.1" ];
      };
      forward-zone = [{
        name = ".";
        forward-addr = [
          # Change this
          "45.90.28.0#nixOS--${hostName}-${nextdnsProfile}.dns.nextdns.io"
          "2a07:a8c0::#nixOS--${hostName}-${nextdnsProfile}.dns.nextdns.io"
          "45.90.30.0#nixOS--${hostName}-${nextdnsProfile}.dns.nextdns.io"
          "2a07:a8c1::#nixOS--${hostName}-${nextdnsProfile}.dns.nextdns.io"
        ];
        forward-tls-upstream = true; # Protected DNS
      }];
    };
  };
}
