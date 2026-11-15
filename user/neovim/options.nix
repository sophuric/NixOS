# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
{
  programs.nixvim.opts = {
    number = true;
    relativenumber = true;
    autoindent = true;
    expandtab = false;
    shiftwidth = 4;
    smartindent = true;
    tabstop = 4;
    softtabstop = 4;

    wildmenu = true;

    mouse = "a";

    foldenable = true;
    foldlevelstart = 5;
  };
  programs.nixvim.clipboard.register = "unnamedplus";
}
