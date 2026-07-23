# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
{ pkgs, ... }: {
  services.greetd = {
    enable = true;
    settings = {
      default_session.command =
        "${pkgs.tuigreet}/bin/tuigreet -t --time-format '%F %H:%M:%S' --remember --remember-user-session --user-menu --asterisks --asterisks-char '◆' --window-padding 2";
    };
  };
}
