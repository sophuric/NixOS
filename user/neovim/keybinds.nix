# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
{
  util,
  lib,
  ...
}:
{
  programs.nixvim.keymaps =
    map
      (
        x:
        util.merge [
          {
            key = x.name;
            options = {
              noremap = true;
              silent = true;
            };
          }
          (if lib.isString x.value then { action = x.value; } else x.value)
          (
            if x.value ? mode && x.value.mode == "all" then
              {
                mode = [
                  ""
                  "t"
                  "l"
                ];
              }
            else
              { }
          )
        ]
      )
      (
        lib.attrsets.attrsToList {
          "<MiddleMouse>" = {
            action = "";
            mode = "all";
          };
          "<2-MiddleMouse>" = {
            action = "";
            mode = "all";
          };
          "<3-MiddleMouse>" = {
            action = "";
            mode = "all";
          };
          "<4-MiddleMouse>" = {
            action = "";
            mode = "all";
          };
          "<C-Q>" = "<cmd>bd<CR>";
          "<C-S-Q>" = "<cmd>bd<CR>";
          "<C-T>" = "<cmd>enew<CR>";
          "<C-S-T>" = "<cmd>enew<CR>";
          "<C-`>" = "<cmd>BufferLineCycleNext<CR>";
          "<C-Tab>" = "<cmd>BufferLineCycleNext<CR>";
          "<C-Right>" = "<cmd>BufferLineCycleNext<CR>";
          "<C-S-Right>" = "<cmd>BufferLineCycleNext<CR>";
          "<C-S-`>" = "<cmd>BufferLineCyclePrev<CR>";
          "<C-S-Tab>" = "<cmd>BufferLineCyclePrev<CR>";
          "<C-Left>" = "<cmd>BufferLineCyclePrev<CR>";
          "<C-S-Left>" = "<cmd>BufferLineCyclePrev<CR>";
          "<C-/>" = {
            action = "<cmd>let @/ = \"\"<CR>";
            options.desc = "Clear search query";
          };
          "<C-S-/>" = {
            action = "/\\<\\><Left><Left>";
            options.desc = "Search word";
            options.silent = false;
          };
          "<C-Up>" = {
            action = "g<Up>";
            options.desc = "Go up visual line";
          };
          "<C-Down>" = {
            action = "g<Down>";
            options.desc = "Go down visual line";
          };
          "<C-Backspace>" = {
            action = "db";
            options.desc = "Backspace word";
          };
          "<C-Delete>" = {
            action = "dw";
            options.desc = "Delete word";
          };
          # TOOD: Tree view ^O
        }
      );
}
