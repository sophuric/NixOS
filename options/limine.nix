# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
{ pkgs, ... }: {
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
      };
    };
  };
  catppuccin.limine.enable = true;
}
