{ ... }:
{ config, lib, pkgs, osConfig, ... }:
{
  imports = [ ./bar ];

  wayland.windowManager.sway = rec {
    enable = osConfig.programs.sway.enable;
    package = osConfig.programs.sway.package;
    systemd.enable = true;

    config = {
      modifier = "Mod4";
      terminal = lib.getExe pkgs.foot;
      bars = [ ];

      keybindings =
        let
          modifier = config.modifier;
          brightnessctl = lib.getExe pkgs.brightnessctl;
          wpctl = lib.getExe' pkgs.wireplumber "wpctl";
        in
        lib.mkOptionDefault {
          "${modifier}+l" = "exec ${lib.getExe' pkgs.systemd "loginctl"} lock-session";

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
        "*" = {
          bg = "${pkgs.nixos-artwork.wallpapers.dracula.gnomeFilePath} fill";
        };
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
        outer = 10;
        inner = 10;
      };
    };
  };

  programs.swaylock = {
    enable = true;
    settings.image = pkgs.nixos-artwork.wallpapers.dracula.gnomeFilePath;
  };

  services.swayidle =
    let
      swaylock = "${lib.getExe pkgs.swaylock} -f";
      swaymsg = lib.getExe' pkgs.sway "swaymsg";
    in
    {
      enable = true;
      systemdTarget = "sway-session.target";

      timeouts = [
        {
          timeout = 60 * 5;
          command = swaylock;
        }
        {
          timeout = 60 * 6;
          command = "${swaymsg} 'output * dpms off'";
          resumeCommand = "${swaymsg} 'output * dpms on'";
        }
      ];

      events = [
        {
          event = "before-sleep";
          command = swaylock;
        }
        {
          event = "lock";
          command = swaylock;
        }
      ];
    };
}

