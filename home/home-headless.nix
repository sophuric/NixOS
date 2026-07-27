# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
args@{
  config,
  lib,
  inputs,
  ...
}:
{
  imports = [
    inputs.nur.modules.homeManager.default
    inputs.catppuccin.homeModules.catppuccin
    ./neovim.nix
    ./shell.nix
  ];

  options = {
    allowUnfreePackages = lib.mkOption {
      type = lib.types.listOf lib.types.anything;
      default = [ ];
      description = "List of package names as a string, or predicates that accept a package name as a string";
      # This allows mkMerge to work with this
    };
  };

  config = {
    nixpkgs.config.allowUnfreePredicate = (
      pkg:
      builtins.any (
        x: (if builtins.isFunction x then (x pkg) else (x == (lib.getName pkg)))
      ) config.allowUnfreePackages
    );

    catppuccin = {
      accent = "pink";
      flavor = "mocha";
      kvantum = {
        apply = true;
        enable = true;
      };
    };

    manual.html.enable = true;
    manual.manpages.enable = true;
    home.preferXdgDirectories = true;

    programs.kitty.enable = true; # for terminfo

    home.stateVersion = "25.05"; # Do not change
  };
}
