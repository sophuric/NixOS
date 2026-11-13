# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
{
  programs.nixvim.plugins.visual-whitespace = {
    enable = true;
    settings = {
      highlight = {
        link = "Visual";
      };
      space_char = "·";
      tab_char = "→";
      nl_char = "↲";
      cr_char = "←";
    };
  };
}
