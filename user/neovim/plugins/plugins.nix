# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
{
  lib,
  ...
}:
{
  imports = [
    ./autopairs.nix
    ./bufferline.nix
    ./catppuccin.nix
    ./visual-whitespace.nix
    ./tiny-inline-diagnostic.nix
    ./cmp.nix
    ./lsp.nix
  ];
  programs.nixvim.plugins =
    lib.genAttrs
      [
        "web-devicons"
      ]
      (name: {
        enable = true;
      });
}
