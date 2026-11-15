# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
{
  config,
  ...
}:
let
  nixvim = config.lib.nixvim;
in
{
  programs.nixvim.plugins.bufferline = {
    enable = true;
    settings.options = {
      max_name_length = 14;
      max_prefix_length = 10;
      tab_size = 20;

      color_icons = true;
      show_buffer_icons = true;
      show_buffer_close_icons = true;

      show_close_icon = true;
      show_tab_indicators = true;

      enforce_regular_tabs = true;
      persist_buffer_sort = true;
      always_show_bufferline = true;

      separator_style = "thin";

      highlights = nixvim.mkRaw "require(\"catppuccin.special.bufferline\").get_theme()";
    };
  };
}
