# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
args@{ self, config, lib, pkgs, util, ... }:
let
  getDataDirName = x:
    "JetBrains/${
    # this is kinda hacky
      (lib.importJSON (x + /${x.pname}/product-info.json)).dataDirectoryName
    }";
in {
  home.packages = [
    (pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains.idea-community [
      "catppuccin-theme"
      "minecraft-development"
      "ideavim"
    ])
  ];
  xdg.configFile = util.merge (builtins.map (x: {
    "${getDataDirName pkgs.jetbrains.idea-community}/options/${x}".source =
      ./${x};
  }) [
    "colors.scheme.xml"
    "editor-font.xml"
    "ide.general.xml"
    "laf.xml"
    "vim_settings.xml"
    "linux/keymap.xml"
  ]);
}
