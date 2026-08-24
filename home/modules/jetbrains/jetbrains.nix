# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
args@{
  inputs,
  lib,
  pkgs,
  util,
  ...
}:
let
  getProductInfo = x: lib.importJSON (x + /${x.pname}/product-info.json);
  getDataDirName =
    x:
    "JetBrains/${
      # this is kinda hacky
      (getProductInfo x).dataDirectoryName
    }";
  plugins = [
    "com.github.catppuccin.jetbrains"
    "IdeaVIM"
  ];
  ides = with pkgs.jetbrains; [
    {
      package = idea-oss;
      plugins = [
        "com.demonwav.minecraft-dev"
      ];
    }
    {
      package = rider;
      plugins = [ ];
    }
    {
      package = clion;
      plugins = [ ];
    }
  ];
  unfree-ides = with pkgs.jetbrains; [
    rider
    clion
  ];
in
{
  home.packages = builtins.map (
    ide:
    (pkgs.jetbrains.plugins.addPlugins ide.package (
      lib.attrValues (
        inputs.nix-jetbrains-plugins.lib.pluginsForIde pkgs ide.package (plugins ++ ide.plugins)
      )
    ))
  ) ides;
  xdg.configFile = util.merge (
    builtins.concatMap (
      ide:
      let
        dir = getDataDirName ide.package;
      in
      builtins.map (x: { "${dir}/options/${x}".source = ./${x}; }) [
        "colors.scheme.xml"
        "editor-font.xml"
        "ide.general.xml"
        "laf.xml"
        "vim_settings.xml"
        "linux/keymap.xml"
        "other.xml"
      ]
    ) ides
  );
  allowUnfreePackages =
    (builtins.map (x: x.pname) unfree-ides)
    ++ (builtins.map (x: x.pname + "-with-plugins") unfree-ides);
}
