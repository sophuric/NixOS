# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
{ pkgs, ... }: {
  boot.loader.timeout = 3;
  boot.loader.limine = {
    enable = true;
    efiSupport = true;
    enableEditor = true;
    additionalFiles = {
      "efi/memtest86+.efi" = "${pkgs.memtest86plus}/mt86plus.efi";
    };
    panicOnChecksumMismatch = true;
    extraEntries = ''
      /Memtest86+
      	protocol: chainload
      	path: boot():///efi/memtest86+.efi
    '';
    style = {
      interface = {
        helpHidden = true;
        branding = null;
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
