# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
{ config, ... }: {
  services.webdav = {
    enable = true;
    environmentFile = "/root/webdav.env";
    settings = {
      address = "localhost";
      port = 57259;
      users = [{
        username = "sophie";
        password = "{env}SOPHIE_PASS";
        directory = "${config.users.users.sophie.home}/.webdav";
        permissions = "CRUD";
      }];
    };
  };

  systemd.user.tmpfiles.users.sophie.rules = [
    "d %h/.webdav 700 sophie sophie - -" # create ~/.webdav directory
    "a %h - - - - u:webdav:--x" # allow webdav to enter home dir but not read
    "A %h/.webdav - - - - u:webdav:rwx" # allow webdav to read/modify ~/.webdav
  ];
}
