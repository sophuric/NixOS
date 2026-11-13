# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
{
  config,
  util,
  ...
}:
{
  programs.nixvim.colorschemes.catppuccin =
    let
      palette = util.getPalette config;
    in
    {
      enable = true;
      settings = {
        custom_highlights = {
          LineNr = {
            fg = palette.overlay1.hex;
          };
        };
        flavor = config.catppuccin.flavor;
        term_colors = true;
        transparent_background = true;
        auto_integrations = true;
        show_end_of_buffer = true;
      };
    };
}
