# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
{ ... }: {
  services.openssh = {
    enable = true;
    ports = [ 13519 ];
    settings = {
      KbdInteractiveAuthentication = false;
      PasswordAuthentication = false;
      PubkeyAuthentication = true;
      PermitRootLogin = "no";
      X11Forwarding = false;
      GatewayPorts = "no";
      AllowGroups = [ "ssh" ];
      UseDns = false;
    };
    allowSFTP = true;
  };
  users.groups = {
    ssh = { };
  };
}
