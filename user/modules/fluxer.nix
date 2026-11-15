# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
{ pkgs, inputs, ... }: {
  home.packages = [
    inputs.fluxer.packages.${pkgs.stdenv.hostPlatform.system}.fluxer
  ];
}
