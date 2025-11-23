# vim: fixeol eol expandtab tabstop=2 shiftwidth=2

args@{ lib, ... }:
with builtins; rec {
  ensureList = x: if builtins.isList x then x else [ x ];
  trimNewlines = x: (replaceStrings [ "\n" "\r" ] [ "" "" ] x);
  first = x: (elemAt x 0);
  startsWith = string: substring:
    ((builtins.substring 0 (stringLength substring) string) == substring);
  endsWith = string: substring:
    (if stringLength string >= stringLength substring then
      ((builtins.substring ((stringLength string) - (stringLength substring))
        (stringLength substring) string) == substring)
    else
      false);
  replacePrefix = string: substring: newSubstring:
    (if startsWith string substring then
      newSubstring
      + (builtins.substring (stringLength substring) (stringLength string)
        string)
    else
      string);
  replaceSuffix = string: substring: newSubstring:
    (if endsWith string substring then
      (builtins.substring 0 ((stringLength string) - stringLength substring)
        string) + newSubstring
    else
      string);
  listEquals = list1: list2: (sort lessThan list1) == (sort lessThan list2);
  # Recursively merge attrset or list
  # This is because {a.b=2;}//{a.c=3;} will produce {a={c=3;};} because // doesn't recursively merge an attrset
  merge = foldl' (acc: elem:
    (if (isAttrs acc && isAttrs elem) then
      ((mapAttrs (name: value: # map list of acc
        (if elem ? ${name} then
        # recursively merge the two values if elem has the attribute too
          merge ([ value elem.${name} ])
        else
          value # else use the attribute from elem
        )) acc) //
        # add attributes from elem that are not within acc
        (lib.filterAttrs (name: value: !(acc ? ${name})) elem))
    else if (isList acc && isList elem) then
      (acc ++ elem) # concat lists
    else if (isNull elem) then
      acc
    else
      elem)) [ ];
  escapeCss = x: ''"${lib.strings.escape [ ''"'' "\n" ] x}"'';
  # https://github.com/catppuccin/nix/blob/06f0ea19/modules/home-manager/fzf.nix#L8
  getPalette = config:
    (lib.importJSON
      "${config.catppuccin.sources.palette}/palette.json").${config.catppuccin.flavor}.colors;
  toRGB = { r, g, b }: "rgb(${toString r}, ${toString g}, ${toString b})";
  toHSL = { h, s, l }:
    "hsl(${toString h}deg, ${toString (s * 100)}%, ${toString (l * 100)}%)";
}
