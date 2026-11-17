# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
{
  config,
  lib,
  pkgs,
  ...
}:
{
  boot.loader.timeout = 3;
  boot.loader.limine = {
    enable = lib.mkDefault true;
    efiSupport = lib.mkDefault true;
    enableEditor = true;
    additionalFiles = lib.mkIf config.boot.loader.limine.efiSupport {
      "efi/memtest86+.efi" = "${pkgs.memtest86plus}/mt86plus.efi";
    };
    panicOnChecksumMismatch = true;
    extraEntries = lib.mkIf config.boot.loader.limine.efiSupport ''
      /Memtest86+
      	protocol: chainload
      	path: boot():///efi/memtest86+.efi
    '';
    maxGenerations = 50;
    style = {
      interface = {
        helpHidden = true;
        branding = null;
      };
      wallpapers = [ ];
      wallpaperStyle = "centered";
      graphicalTerminal = {
        margin = 64;
        marginGradient = 24;
      };
    };
  };
  catppuccin.limine.enable = true;
}
