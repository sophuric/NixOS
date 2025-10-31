# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
{ self, config, pkgs, lib, ... }: {
  enable = true;
  settings = {
    kitty_mod = "ctrl+shift";
    clear_all_shortcuts = true;
    confirm_os_window_close = 1;
    enable_audio_bell = false;
    tab_bar_edge = "top";
    tab_bar_style = "powerline";
    tab_bar_align = "left";
    tab_bar_min_tabs = 2;
    active_tab_foreground = "#11111b";
    active_tab_background = "#f5c2e7";
    active_tab_font_style = "bold";
    inactive_tab_foreground = "#f5c2e7";
    inactive_tab_background = "#181825";
    inactive_tab_font_style = "normal";
    selection_background = "#f5c2e7";
    paste_actions = "quote-urls-at-prompt,confirm,confirm-if-large";
    strip_trailing_spaces = "smart";
    remember_window_size = false;
    remember_window_position = false;
    hide_window_decorations = true;
    background_opacity = 0.75;
  };
  keybindings = {
    "kitty_mod+C" = "copy_to_clipboard";
    "kitty_mod+V" = "paste_from_clipboard";
    "kitty_mod+down" = "scroll_line_down";
    "kitty_mod+up" = "scroll_line_up";
    "kitty_mod+J" = "scroll_line_down";
    "kitty_mod+K" = "scroll_line_up";
    "kitty_mod+page_up" = "scroll_page_up";
    "kitty_mod+page_down" = "scroll_page_down";
    "kitty_mod+home" = "scroll_home";
    "kitty_mod+end" = "scroll_end";
    "kitty_mod+F" = "show_scrollback";
    "kitty_mod+G" =
      "launch --type=overlay --stdin-source=@screen_scrollback fzf --no-sort --tac --exact -i";
    "kitty_mod+W" = "close_window";
    "kitty_mod+]" = "next_window";
    "kitty_mod+[" = "previous_window";
    "ctrl+tab" = "next_tab";
    "ctrl+shift+tab" = "previous_tab";
    "kitty_mod+right" = "next_tab";
    "kitty_mod+left" = "previous_tab";
    "kitty_mod+t" = "new_tab";
    "kitty_mod+." = "move_tab_forward";
    "kitty_mod+," = "move_tab_backward";
    "ctrl+alt+tab" = "set_tab_title";
    "kitty_mod+equal" = "change_font_size all +2.0";
    "kitty_mod+minus" = "change_font_size all -2.0";
    "kitty_mod+0" = "change_font_size all 0";
    "kitty_mod+u" = "kitten unicode_input";
    "kitty_mod+f5" = "load_config_file";
    "kitty_mod+delete" = "clear_terminal reset active";
    "kitty_mod+enter" = "detach_window ask";
  };
}
