# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
{ inputs, ... }:
{
  imports = map (x: inputs.self + /user/${x}) (
    [
      /home-desktop.nix
    ]
    ++ map (x: /modules/${x}) [
      /vesktop.nix
      /fluxer.nix
      /firefox.nix
      /keepassxc.nix
      /jetbrains/jetbrains.nix
      /syncthing.nix
      /libreoffice/libreoffice.nix
      /prism-launcher.nix
    ]
  );
}
