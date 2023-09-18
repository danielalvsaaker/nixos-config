{ pkgs, ... }:
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
          "idle_inhibitor"
        ];

        modules-center = [
          "sway/window"
        ];

        modules-right = [
          "battery"
          "temperature"
          "bluetooth"
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

        "temperature" = {
          critical-threshold = 80;
          interval = 5;
          format = "{temperatureC}°C";
          tooltip = true;
        };

        "battery" = {
          interval = 120;
          states = {
            warning = 20;
            critical = 10;
          };
          format = "{capacity}%";
        };

        "bluetooth" = {
          format = "";
          format-on = "";
          format-disabled = "̸";
          format-off = "̸";
          format-connected = " {device_alias}";
          format-connected-battery = " {device_alias} {device_battery_percentage}%";
          tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
          tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
          tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_address}\t{device_battery_percentage}%";
          on-click-right = "${pkgs.util-linux}/bin/rfkill toggle bluetooth";
        };

        "tray" = {
          icon-size = 21;
          spacing = 10;
        };

        "idle_inhibitor" = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };
      }
    ];
  };
}
