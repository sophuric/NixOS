# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
{
  pkgs,
  config,
  util,
  lib,
  ...
}:
{
  xdg.mimeApps = {
    enable = true;
    defaultApplicationPackages = with pkgs; [
      kitty
      nemo-fileroller
      file-roller
      firefox
      qpdfview
      nemo
      neovim
      libreoffice-qt
    ];
    defaultApplications = {
      "application/json" = [ "nvim.desktop" ];
      "application/x-shellscript" = [ "nvim.desktop" ];
      "inode/directory" = [ "nemo.desktop" ];
    };
  };
}
