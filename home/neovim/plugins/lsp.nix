# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
{ lib, ... }:
{
  programs.nixvim = {
    plugins.lspconfig.enable = true;
    lsp.servers = {
      bashls.enable = true;
      clangd.enable = true;
      lua_ls.enable = true;
      nixd.enable = true;
      ts_ls.enable = true;
    };
    lsp.keymaps =
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
}
