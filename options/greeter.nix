# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
{ pkgs, ... }: {
  services.greetd = {
    vt = 7;
    enable = true;
    settings = {
      default_session.command =
        "${pkgs.greetd.tuigreet}/bin/tuigreet -t --time-format '%F %H:%M:%S' --remember --remember-user-session --user-menu --asterisks --asterisks-char '◆' --window-padding 2";
    };
  };
}
