# vim: fixeol eol expandtab tabstop=2 shiftwidth=2

args@{ self, ... }:
args // {
  trimNewlines = x: (builtins.replaceStrings [ "\n" "\r" ] [ "" "" ] x);
  first = x: (builtins.elemAt x 0);
}
