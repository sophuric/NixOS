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
    (pkgs.writeShellApplication {
      name = "get-last-screenshot.sh";
      # Returns the latest screenshot in the screenshots directory
      text = "find ~/screenshots -type f -printf '%T@ %p\\n' | sort --numeric-sort --reverse | cut -d' ' -f2- | head -1";
    })
    (pkgs.writeShellApplication {
      name = "open-last-screenshot.sh";
      runtimeInputs = [ pkgs.feh ];
      text = ''feh --class=feh-float - < "$(get-last-screenshot.sh)"'';
    })
    (pkgs.writeShellApplication {
      name = "copy-last-screenshot.sh";
      runtimeInputs = [ pkgs.wl-clipboard ];
      text = ''wl-copy < "$(get-last-screenshot.sh)"'';
    })
    (pkgs.writeShellApplication {
      name = "notify-copy-temp-file.sh";
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
      name = "zbar-last-screenshot.sh";
      # Scans the last screenshot for barcodes with ZBar
      runtimeInputs = with pkgs; [
        zbar
        neovim
        libnotify
        wl-clipboard
        kitty
      ];
      text = ''
        TMP="$(mktemp)"
        zbarimg --quiet --raw - < "$(get-last-screenshot.sh)" > "$TMP" || {
          [[ "$?" == "4" ]] && {
            notify-send "No barcodes were detected"
            rm -- "$TMP"
            false
          }
        }
        notify-copy-temp-file.sh "$TMP" "Decoded data"
      '';
    })
    (pkgs.writeShellApplication {
      name = "ocr-last-screenshot.sh";
      # Scans text in the last screenshot with Tesseract
      runtimeInputs = with pkgs; [
        tesseract
        neovim
        libnotify
        wl-clipboard
        kitty
      ];
      text = ''
        TMP="$(mktemp)"
        tesseract - - < "$(get-last-screenshot.sh)" > "$TMP"
        [[ -s "$TMP" ]] || {
          notify-send "No text was detected"
          rm -- "$TMP"
          false
        }
        notify-copy-temp-file.sh "$TMP" "Text"
      '';
    })
  ];
}
