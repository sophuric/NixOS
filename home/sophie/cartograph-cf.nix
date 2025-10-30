# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
{ self, config, pkgs, lib, ... }:

pkgs.stdenv.mkDerivation {
  # https://github.com/redyf/font-flake/blob/6c3d87082541/flake.nix#L85-L93
  name = "CartographCF";
  # "you wouldn't download a font"
  src = pkgs.fetchgit {
    url = "https://github.com/g5becks/Cartograph.git";
    rev = "eecba04db96206933496a8b845f68c19decb3c64";
    sha256 = "P8cii7ez9bAE+c7tN+oWQy3/LQPFtGUmlwQsKevbl0M=";
  };
  installPhase =
    "	mkdir -p $out/share/fonts/opentype\n	find $src -type f -name '*.otf' -exec cp {} $out/share/fonts/opentype/ \\;\n";
}
