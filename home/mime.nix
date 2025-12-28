# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
{ pkgs, config, util, lib, ... }: {
  xdg.mimeApps = {
    enable = true;
    defaultApplicationPackages = with pkgs; [
      nemo-fileroller
      file-roller
      config.programs.zen-browser.package
      qpdfview
      nemo
      neovim
      libreoffice-qt
    ];
    defaultApplications = {
      "application/json" = [ "nvim.desktop" ];
    };
  };
}
