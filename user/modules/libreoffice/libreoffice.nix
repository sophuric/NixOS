# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
{
  util,
  self,
  config,
  pkgs,
  lib,
  ...
}:
{
  home.packages = [ pkgs.libreoffice-qt ];
  xdg.configFile =
    let
      ctp = config.catppuccin;
      ctp-dir = ctp-repo + /themes/${ctp.flavor}/${ctp.accent};
      ctp-name = "catppuccin-${ctp.flavor}-${ctp.accent}";
      ctp-path = ctp-dir + "/${ctp-name}";
      ctp-repo = pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "libreoffice";
        rev = "ffcbb74525eb2837b214cd5a3f2570eb7b1f3dc0";
        sha256 = "sha256-NAQJPIbJVUZFkFfdyywv1A38N06gwdLd5Uge6eqPPJM=";
      };
    in
    util.merge (
      lib.attrValues (
        builtins.mapAttrs
          (name: content: {
            "libreoffice/4/user/${name}" = {
              source = pkgs.writeText name content;
              force = true;
            };
          })
          {
            "config/${ctp-name}.soc" = builtins.readFile (ctp-path + ".soc");
            "registrymodifications.xcu" =
              lib.replaceStrings
                [ "<catppuccin-file/>" "catppuccin-theme" ]
                [
                  (builtins.readFile (ctp-path + ".xcu"))
                  ("Catppuccin ${ctp.flavor} - ${ctp.accent}")
                ]
                (builtins.readFile ./registrymodifications.xcu);
          }
      )
    );
}
