# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
args@{ lib, pkgs, ... }: {
  imports = [
    args.nur.modules.homeManager.default
    args.catppuccin.homeModules.catppuccin
    ./nvim.nix
    ./shell.nix
    ./syncthing.nix
  ];

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

  home.stateVersion = "25.05"; # Do not change
}
