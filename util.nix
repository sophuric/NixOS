# vim: fixeol eol expandtab tabstop=2 shiftwidth=2

with builtins;
{ lib, ... }:
let
  traceAll = foldl' (_: x: trace x null) null;
  mergeLists = foldl' (acc: cur: acc ++ cur) [ ];
  mergeCustom =
    selfMergeFunc: other: x:
    if length x == 1 then
      head x
    else if length x > 1 && all isAttrs x then
      zipAttrsWith (name: selfMergeFunc) x
    else if length x > 1 && all isList x then
      mergeLists x
    else
      other x (
        # Doesn't match other conditions, fail
        if length x == 0 then
          throw "Cannot merge no items"
        else
          trace "Trying to merge" seq (traceAll x) throw "Don't know how to merge this"
      );
in
rec {
  # Recursively merge attrset or list
  # This is because {a.b=2;}//{a.c=3;} will produce {a={c=3;};} because // doesn't recursively merge an attrset
  merge = mergeCustom merge (x: fail: fail);
  mergeFirst = mergeCustom mergeFirst (x: fail: if length x > 0 then head x else fail);
  mergeLast = mergeCustom mergeLast (x: fail: if length x > 0 then last x else fail);
  inherit mergeLists;

  allSystems = lib.systems.flakeExposed;
  ensureList = x: if builtins.isList x then x else [ x ];
  trimNewlines = x: (replaceStrings [ "\n" "\r" ] [ "" "" ] x);
  last = x: (elemAt x (length x - 1));
  startsWith =
    string: substring: ((builtins.substring 0 (stringLength substring) string) == substring);
  endsWith =
    string: substring:
    (
      if stringLength string >= stringLength substring then
        (
          (builtins.substring (
            (stringLength string) - (stringLength substring)
          ) (stringLength substring) string) == substring
        )
      else
        false
    );
  replacePrefix =
    string: substring: newSubstring:
    (
      if startsWith string substring then
        newSubstring + (builtins.substring (stringLength substring) (stringLength string) string)
      else
        string
    );
  replaceSuffix =
    string: substring: newSubstring:
    (
      if endsWith string substring then
        (builtins.substring 0 ((stringLength string) - stringLength substring) string) + newSubstring
      else
        string
    );
  indexesOf =
    string: substring:
    (map (x: substring == builtins.substring x (stringLength substring) string) (
      lib.lists.range 0 (stringLength string - stringLength substring)
    ));
  firstIndexOf =
    string: substring: (lib.lists.findFirstIndex (x: x) null (indexesOf string substring));
  listEquals = list1: list2: (sort lessThan list1) == (sort lessThan list2);
  escapeCss = x: ''"${lib.strings.escape [ ''"'' "\n" ] x}"'';
  # https://github.com/catppuccin/nix/blob/06f0ea19/modules/home-manager/fzf.nix#L8
  getPalette =
    config:
    let
      colors = (
        (lib.importJSON "${config.catppuccin.sources.palette}/palette.json")
        .${config.catppuccin.flavor}.colors
      );
    in
    colors // { accent = colors.${config.catppuccin.accent}; };
  toRGB =
    {
      r,
      g,
      b,
    }:
    "rgb(${toString r}, ${toString g}, ${toString b})";
  toHSL =
    {
      h,
      s,
      l,
    }:
    "hsl(${toString h}deg, ${toString (s * 100)}%, ${toString (l * 100)}%)";
}
