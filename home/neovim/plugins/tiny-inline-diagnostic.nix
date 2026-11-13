# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
{
  programs.nixvim.plugins.tiny-inline-diagnostic = {
    enable = true;
    settings = {
      preset = "modern";
      transparent_bg = true;
      options = {
        show_code = true;
        use_icons_from_diagnostic = false;
        throttle = 50;
        softwrap = 30;
        multilines.enabled = true;
        show_all_diags_on_cursorline = true;
        show_diags_only_under_cursor = true;
      };
    };
  };
}
