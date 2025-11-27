# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
{ util, self, config, pkgs, lib, ... }: {
  home = let cfg = import (self + /local.nix); # This is hacky
  in {
    packages = (with pkgs; [ libreoffice-qt hunspell ]) ++ (builtins.map (x:
      pkgs.hunspellDicts.${builtins.substring 0 (util.firstIndexOf x ".") x})
      ([ cfg.i18n.defaultLocale ] ++ cfg.i18n.extraLocales));
  };
  xdg.configFile = util.merge
    (builtins.map (x: { "libreoffice/4/user/${x}".source = ./${x}; })
      [ "registrymodifications.xcu" ]);
}
