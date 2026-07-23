# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
{ util, self, config, pkgs, lib, ... }: {
  home.packages = [ pkgs.libreoffice-qt ];
  xdg.configFile = util.merge (builtins.map (x: {
    "libreoffice/4/user/${x}" = {
      source = ./${x};
      force = true;
    };
  }) [ "registrymodifications.xcu" ]);
}
