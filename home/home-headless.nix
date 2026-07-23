# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
args@{ inputs, ... }: {
  imports = [
    inputs.nur.modules.homeManager.default
    inputs.catppuccin.homeModules.catppuccin
    ./neovim.nix
    ./shell.nix
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

  programs.kitty.enable = true; # for terminfo

  home.stateVersion = "25.05"; # Do not change
}
