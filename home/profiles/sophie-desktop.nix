# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
args@{ ... }: {
  imports = [
    ../home-desktop.nix
    ../modules/vesktop.nix
    ../modules/firefox.nix
    ../modules/keepassxc.nix
    ../modules/jetbrains/jetbrains.nix
    ../modules/syncthing.nix
    ../modules/libreoffice/libreoffice.nix
  ];
}
