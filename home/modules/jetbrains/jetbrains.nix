# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
args@{ inputs, lib, pkgs, util, ... }:
let
  getProductInfo = x: lib.importJSON (x + /${x.pname}/product-info.json);
  getDataDirName = x:
    "JetBrains/${
    # this is kinda hacky
      (getProductInfo x).dataDirectoryName
    }";
  idea = pkgs.jetbrains.idea-oss;
  plugins = inputs.nix-jetbrains-plugins.lib.pluginsForIde pkgs idea [
    "com.github.catppuccin.jetbrains"
    "com.demonwav.minecraft-dev"
    "IdeaVIM"
  ];
in {
  home.packages =
    [ (pkgs.jetbrains.plugins.addPlugins idea (lib.attrValues plugins)) ];
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
