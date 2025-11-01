# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
{ pkgs, ... }:

{
  boot.loader.timeout = 3;
  boot.loader.limine = {
    enable = true;
    efiSupport = true;
    enableEditor = true;
    additionalFiles = {
      "efi/memtest86+/memtest.efi" = "${pkgs.memtest86plus}/memtest.efi";
    };
    panicOnChecksumMismatch = true;
    extraEntries = ''
      /Memtest86+
      	protocol: chainload
      	path: boot():///efi/memtest86+/memtest.efi
    '';
    style = {
      interface = {
        helpHidden = true;
        branding = null;
        brandingColor = 0;
      };
      wallpapers = [ ./limine_bg.bmp ];
      wallpaperStyle = "centered";
      graphicalTerminal = {
        margin = 64;
        marginGradient = 24;
        palette = "1e1e2e;f38ba8;a6e3a1;f9e2af;89b4fa;f5c2e7;94e2d5;cdd6f4";
        brightPalette =
          "585b70;f38ba8;a6e3a1;f9e2af;89b4fa;f5c2e7;94e2d5;cdd6f4";
        background = "1e1e2e";
        brightBackground = "585b70";
        foreground = "cdd6f4";
        brightForeground = "cdd6f4";
      };
    };
  };

}
