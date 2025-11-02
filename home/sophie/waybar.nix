# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
{ pkgs, ... }: {
  home.packages = [ pkgs.waybar-mpris ];
  catppuccin.waybar = {
    enable = true;
    mode = "createLink";
  };
  programs.waybar = {
    enable = true;
    style = ./waybar.css;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 0;
        spacing = 0;
        modules-left = [ ];
        modules-center = [ ];
        modules-right =
          [ "battery" "custom/waybar-mpris" "pulseaudio" "clock" "tray" ];
        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon}{capacity}%";
          format-charging = "{icon}󱐋 {capacity}%";
          format-plugged = "{icon} {capacity}%";
          format-icons = [ " " " " " " " " " " ];
        };
        "custom/waybar-mpris" = {
          return-type = "json";
          exec =
            "waybar-mpris --position --autofocus --order 'SYMBOL:ARTIST:TITLE:POSITION' --pause '▶️' --play '⏸️'";
          on-click = "waybar-mpris --send toggle";
          escape = true;
        };
        clock = {
          actions = {
            on-click-right = "mode";
            on-scroll-down = "shift_down";
            on-scroll-up = "shift_up";
          };
          calendar = {
            format = {
              days = "<span color='#89b4fa'>{}</span>";
              months = "<span color='#f9e2af'>{}</span>";
              today = "<span color='#f5c2e7'><b><u>{}</u></b></span>";
              weekdays = "<span color='#fab387'>{}</span>";
              weeks = "<span color='#94e2d5'>w{}</span>";
            };
            mode = "year";
            mode-mon-col = 3;
            on-scroll = -1;
            weeks-pos = "right";
          };
          format = "🕒 {:%Y-%m-%d %a %H:%M:%S}";
          interval = 1;
          tooltip = true;
          tooltip-format = ''
            <tt><span font_size="200%">{:%Y}</span>\n<small>{calendar}</small></tt>'';
        };
        tray = { spacing = 10; };
        pulseaudio = {
          scroll-step = 1;
          format = "{volume}% {icon} {format_source}";
          format-muted = "󰝟 {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = "󰝟  {format_source}";
          format-source = "{volume}% ";
          format-source-muted = " ";
          format-icons = {
            headphone = "󰋋 ";
            hands-free = "󰋎 ";
            headset = "󰋎 ";
            phone = " ";
            portable = " ";
            car = " ";
            default = [ "󰕿" "󰖀" " " ];
          };
          on-click = "pavucontrol";
          on-click-right = "pavucontrol";
        };
      };
    };
    systemd.enable = true;
  };
}
