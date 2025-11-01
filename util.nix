# vim: fixeol eol expandtab tabstop=2 shiftwidth=2

args@{ self, ... }:
with builtins; {
  trimNewlines = x: (replaceStrings [ "\n" "\r" ] [ "" "" ] x);
  first = x: (elemAt x 0);
}
