# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
{
  inputs,
  ...
}:
{
  imports = [
    inputs.nixvim.homeModules.nixvim
    ./keybinds.nix
    ./options.nix
    ./plugins/plugins.nix
  ];
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    waylandSupport = true;
    withNodeJs = true;
    withPerl = true;
    withPython3 = true;
    withRuby = true;

    enableMan = true;

    editorconfig.enable = true;
  };
  home.sessionVariables = {
    MANPAGER = "nvim +Man!";
  };
}
