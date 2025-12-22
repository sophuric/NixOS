# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
args@{ self, config, lib, pkgs, util, ... }:
let
  getDataDirName = x:
    "JetBrains/${
    # this is kinda hacky
      (lib.importJSON (x + /${x.pname}/product-info.json)).dataDirectoryName
    }";
  idea = pkgs.jetbrains.idea-oss;
in {
  home.packages = [
    (pkgs.jetbrains.plugins.addPlugins idea [
      "catppuccin-theme"
      "minecraft-development"
      "ideavim"
    ])
  ];
  xdg.configFile = util.merge (builtins.map
    (x: { "${getDataDirName idea}/options/${x}".source = ./${x}; }) [
      "colors.scheme.xml"
      "editor-font.xml"
      "ide.general.xml"
      "laf.xml"
      "vim_settings.xml"
      "linux/keymap.xml"
      "other.xml"
    ]);
}
