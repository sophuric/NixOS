# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  programs.nixvim = {
    extraPackages =
      with inputs.nixvim.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system}; [
        nixfmt
        shfmt
        stylua
        rustc
        cargo
        clippy
        rustfmt
      ];
    plugins.lspconfig.enable = true;
    lsp = {
      servers = {
        bashls.enable = true;
        clangd.enable = true;
        lua_ls.enable = true;
        nixd.enable = true;
        ts_ls.enable = true;
        rust_analyzer = {
          enable = true;
          config.settings.rust-analyzer = {
            check = {
              command = "clippy";
            };
          };
        };
      };
      keymaps =
        map
          (x: {
            key = x.name;
            lspBufAction = x.value;
          })
          (
            lib.attrsets.attrsToList {
              "gd" = "definition";
              "gD" = "references";
              "gt" = "type_definition";
              "gi" = "implementation";
              "K" = "hover";
              "<C-K><C-D>" = "format";
            }
          );
    };
  };
}
