# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
{
  config,
  ...
}:
let
  nixvim = config.lib.nixvim;
in
{
  programs.nixvim.plugins.cmp = {
    enable = true;
    autoEnableSources = true;

    settings.sources = map (x: { name = x; }) [
      "nvim_lsp"
      "path"
      "buffer"
    ];
    settings.mapping = builtins.mapAttrs (_: x: nixvim.mkRaw "cmp.mapping.${x}") {
      "<C-k>" = "scroll_docs(-10)";
      "<C-j>" = "scroll_docs(1)";
      "<C-b>" = "scroll_docs(-4)";
      "<C-f>" = "scroll_docs(4)";
      "<C-e>" = "abort()";
      "<Tab>" = "select_next_item()";
      "<S-Tab>" = "select_prev_item()";
      "<CR>" = "confirm {select = false, behavior = cmp.ConfirmBehavior.Insert}";
    };
    cmdline = {
      "/" = {
        mapping = nixvim.mkRaw "cmp.mapping.preset.cmdline()";
        sources = [
          { name = "buffer"; }
        ];
      };
      ":" = {
        mapping = nixvim.mkRaw "cmp.mapping.preset.cmdline()";
        sources = [
          { name = "path"; }
          {
            name = "cmdline";
            option = {
              ignore_cmds = [
                "Man"
                "!"
              ];
            };
          }
        ];
      };
    };
  };
}
