# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
{ pkgs, ... }: {
  home.packages = [
    (pkgs.writeShellApplication {
      name = "emoji-picker";
      runtimeInputs = with pkgs; [
        wl-clipboard
        fuzzel
        libnotify
      ];
      text = ''
        OUT="$(fuzzel --match-mode=fuzzy --dmenu --prompt 'Select Emoji > ' < ${
          pkgs.fetchurl {
            url = "https://github.com/sophuric/emojipicker/raw/7cc87962da618285ac102a8908243e662f180788/emojis";
            hash = "sha256-wy7IcZ5ikT6xr8je46vG3P0Os9S4r2Hn2/abJpfrkrg=";
          }
        })"
        test -n "$OUT"
        EMOJI="$(cut -d' ' -f1 <<< "$OUT")"
        DESC="$(cut -d' ' -f2- <<< "$OUT")"
        notify-send -- "Copied Emoji: $EMOJI" "$DESC"
        printf "%s" "$EMOJI" | wl-copy
      '';
    })
  ];
}
