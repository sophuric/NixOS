# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
{
  pkgs,
  config,
  util,
  lib,
  ...
}:
{
  home.packages = [
    (pkgs.stdenv.mkDerivation {
      name = "get-latest-file";
      sourceRoot = ".";
      srcs = [
        ./get-latest-file-script
        (pkgs.fetchgit {
          name = "sophutil";
          url = "https://github.com/sophuric/sophutil.git";
          rev = "873c0c3c486a4ccafcec2541e81a0ed855a1ebf1";
          sha256 = "f+3AY6d1txYllNLrDBDZnz0zyZqkfFB79heqvIV+t30=";
        })
      ];
      buildPhase = "$CC -I. get-latest-file-script/main.c sophutil/src/{hashmap,fnv1_32,linked_list}.c -o get-latest-file";
      installPhase = "install -Dm755 get-latest-file $out/bin/get-latest-file";
    })
    (pkgs.writeShellApplication {
      name = "get-latest-screenshot";
      # Returns the latest screenshot in the screenshots directory
      text = "get-latest-file latest create f -1 true ~/screenshots";
    })
    (pkgs.writeShellApplication {
      name = "open-latest-screenshot";
      runtimeInputs = [ pkgs.feh ];
      text = ''feh --class=feh-float - < "$(get-latest-screenshot)"'';
    })
    (pkgs.writeShellApplication {
      name = "copy-latest-screenshot";
      runtimeInputs = [ pkgs.wl-clipboard ];
      text = ''LAST="$(get-latest-screenshot)" && wl-copy < "$LAST" && notify-send -i "$LAST" -- "Copied file to clipboard" "$LAST"'';
    })
    (pkgs.writeShellApplication {
      name = "save-clipboard-as-screenshot";
      runtimeInputs = [ pkgs.wl-clipboard ];
      text = ''
        LAST=~/screenshots/"paste-$(date -u +"%F %T").png" && [[ ! -e "$LAST" ]] && printf "%s\n" "$LAST"
        { wl-paste -t image/png > "$LAST" || { rm -fv -- "$LAST"; notify-send "Clipboard does not contain an image/png"; exit 1; }; } && notify-send -i "$LAST" -- "Pasted clipboard to file" "$LAST"
      '';
    })

    (pkgs.writeShellApplication {
      name = "notify-copy-temp-file";
      # Copies a file's content to clipboard, notifies the user that it was copied, and opens it in nvim if the notification is clicked
      runtimeInputs = with pkgs; [
        neovim
        libnotify
        wl-clipboard
        kitty
      ];
      text = ''
        [[ "$#" == 1 ]] || [[ "$#" == 2 ]]
        wl-copy -t text/plain < "$1"
        if [[ -n "$(notify-send --action default=Open -- "''${2:-C}''${2:+ c}opied to clipboard - Click to open in neovim" "$(<"$1")")" ]]; then kitty -- nvim -MR -- "$1"; fi
        rm -- "$1"
      '';
    })
    (pkgs.writeShellApplication {
      name = "zbar-latest-screenshot";
      # Scans the latest screenshot for barcodes with ZBar
      runtimeInputs = with pkgs; [
        zbar
        neovim
        libnotify
        wl-clipboard
        kitty
      ];
      text = ''
        TMP="$(mktemp)"
        zbarimg --quiet --raw - < "$(get-latest-screenshot)" > "$TMP" || {
          [[ "$?" == "4" ]] && {
            notify-send "No barcodes were detected"
            rm -- "$TMP"
            false
          }
        }
        notify-copy-temp-file "$TMP" "Decoded data"
      '';
    })
    (pkgs.writeShellApplication {
      name = "ocr-latest-screenshot";
      # Scans text in the latest screenshot with Tesseract
      runtimeInputs = with pkgs; [
        tesseract
        neovim
        libnotify
        wl-clipboard
        kitty
      ];
      text = ''
        TMP="$(mktemp)"
        tesseract - - < "$(get-latest-screenshot)" > "$TMP"
        [[ -s "$TMP" ]] || {
          notify-send "No text was detected"
          rm -- "$TMP"
          false
        }
        notify-copy-temp-file "$TMP" "Text"
      '';
    })
  ];
}
