# vim: fixeol eol expandtab tabstop=2 shiftwidth=2

args@{ self, ... }:
with builtins; {
  trimNewlines = x: (replaceStrings [ "\n" "\r" ] [ "" "" ] x);
  first = x: (elemAt x 0);
  startsWith = string: substring:
    ((builtins.substring 0 (stringLength substring) string) == string);
  endsWith = string: substring:
    (if stringLength string >= stringLength substring then
      ((builtins.substring (stringLength string - stringLength substring)
        (stringLength substring) string) == substring)
    else
      false);
  listEquals = list1: list2: (sort lessThan list1) == (sort lessThan list2);
}
