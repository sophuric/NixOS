# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
{
  config,
  util,
  pkgs,
  lib,
  ...
}:
{
  catppuccin.swaylock.enable = true;

  programs.swaylock =
    let
      palette = util.getPalette config;
    in
    {
      enable = true;
      settings = {
        font-size = 24;
        show-keyboard-layout = true;
        indicator-idle-visible = false;
        indicator-radius = 100;
        indicator-thickness = 16;
        scaling = "solid_color";
        show-failed-attempts = true;
        # override default catppuccin colours
        ring-color = lib.mkForce palette.surface0.hex;
        bs-hl-color = lib.mkForce palette.red.hex;
        caps-lock-key-hl-color = lib.mkForce palette.yellow.hex;
        caps-lock-bs-hl-color = lib.mkForce palette.peach.hex;
        key-hl-color = lib.mkForce palette.pink.hex;
      };
    };

  services.swayidle =
    let
      lock = "${lib.getExe' pkgs.swaylock "swaylock"} --daemonize";
    in
    {
      enable = true;
      events = {
        lock = lock;
        before-sleep = lock;
      };
      timeouts = [
        {
          timeout = 60;
          command = lock;
        }
      ];
    };
}
