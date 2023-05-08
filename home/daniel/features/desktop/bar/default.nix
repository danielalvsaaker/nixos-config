{
  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      target = "sway-session.target";
    };

    style = ./style.css;

    settings = [
      {
        layer = "bottom";
        position = "top";

        height = 30;

        modules-left = [
          "sway/workspaces"
          "sway/mode"
        ];

        modules-center = [
          "sway/window"
        ];

        modules-right = [
          "memory"
          "cpu"
          "temperature"
          "tray"
          "clock#date"
          "clock#time"
        ];

        "clock#time" = {
          interval = 1;
          format = "{:%H:%M:%S}";
          tooltip = false;
        };

        "clock#date" = {
          interval = 10;
          format = "{:%d.%m.%Y}";
          tooltip = false;
        };

        "cpu" = {
          interval = 5;
          format = "{usage}% ({load})";
          states = {
            warning = 70;
            critical = 90;
          };
        };

        "memory" = {
          interval = 5;
          format = "{}%";
          states = {
            warning = 70;
            critical = 90;
          };
        };

        "temperature" = {
          critical-threshold = 80;
          interval = 5;
          format = "{temperatureC}°C";
          tooltip = true;
        };

        "tray" = {
          icon-size = 21;
          spacing = 10;
        };
      }
    ];
  };
}
