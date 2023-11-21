{ config, lib, pkgs, ... }:
{
  imports = [ ./bar ];

  wayland.windowManager.sway = rec {
    enable = true;
    systemd.enable = true;

    config = {
      modifier = "Mod4";
      terminal = lib.getExe pkgs.foot;
      bars = [ ];

      keybindings =
        let
          modifier = config.modifier;
          swaylock = lib.getExe pkgs.swaylock;
          brightnessctl = lib.getExe pkgs.brightnessctl;
          wpctl = lib.getExe' pkgs.wireplumber "wpctl";
        in
        lib.mkOptionDefault {
          "${modifier}+l" = "exec ${swaylock} -k";

          "XF86MonBrightnessUp" = "exec ${brightnessctl} set +10";
          "XF86MonBrightnessDown" = "exec ${brightnessctl} set 10-";
          "${modifier}+XF86MonBrightnessUp" = "exec ${brightnessctl} -d tpacpi::kbd_backlight set +1";
          "${modifier}+XF86MonBrightnessDown" = "exec ${brightnessctl} -d tpacpi::kbd_backlight set 1-";

          "XF86AudioMute" = "exec ${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle";
          "XF86AudioRaiseVolume" = "exec ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%+ -l 1";
          "XF86AudioLowerVolume" = "exec ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%-";

          "${modifier}+s" = "exec ${lib.getExe pkgs.grim} -g \"$(${lib.getExe pkgs.slurp})\" $(${pkgs.xdg-user-dirs}/bin/xdg-user-dir PICTURES)/$(date +'screenshot_%Y-%m-%d-%H%M%S.png')";
        };

      output = {
        HDMI-A-1 = {
          mode = "2560x1440@74.968Hz";
        };
      };

      floating.criteria =
        let
          class = "^steam$";
        in
        [
          {
            inherit class;
            title = "^Friends List$";
          }
          {
            inherit class;
            title = "Steam - News";
          }
          {
            inherit class;
            title = ".* - Chat";
          }
          {
            inherit class;
            title = "^Settings$";
          }
          {
            inherit class;
            title = "^Steam Guard - Computer Authorization Required$";
          }
        ];

      input = {
        "*" = {
          xkb_layout = "us,us";
          xkb_variant = "colemak_dh,intl";
          xkb_options = "grp:win_space_toggle";
        };
      };
      gaps = {
        outer = 15;
        inner = 15;
      };
    };
  };

  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 60 * 10;
        command = "${pkgs.swaylock}/bin/swaylock -f";
      }
      {
        timeout = 60 * 15;
        command = "${pkgs.sway}/bin/swaymsg 'output * dpms off'";
        resumeCommand = "${pkgs.sway}/bin/swaymsg 'output * dpms on'";
      }
    ];

    events = [
      {
        event = "before-sleep";
        command = "${pkgs.swaylock}/bin/swaylock -f";
      }
    ];
  };
}

