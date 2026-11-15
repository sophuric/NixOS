# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
{
  ...
}:
{
  programs.nixvim.plugins.nvim-autopairs = {
    enable = true;
    settings = {
      disable_in_macro = true; # disable when recording or executing a macro
      disable_in_visualblock = false; # disable when insert after visual block mode
      disable_in_replace_mode = true;
      enable_moveright = true;
      enable_afterquote = true; # add bracket pairs after quote
      enable_check_bracket_line = true; # check bracket in same line
      enable_bracket_in_quote = true;
      enable_abbr = false; # trigger abbreviation
      break_undo = true; # switch for basic rule break undo sequence
      check_ts = false;
      map_cr = true;
      map_bs = true; # map the <BS> key
      map_c_h = false; # Map the <C-h> key to delete a pair
      map_c_w = false; # map <c-w> to delete a pair if possible
    };
  };
}
