{ lib, pkgs, ... }:
{
  wayland.windowManager.sway = rec {
    enable = true;
    config = {
      modifier = "Mod4";
      # Use kitty as default terminal
      terminal = "foot";
      startup = [
        # Launch Firefox on start
        { command = "firefox"; }
      ];

      left = "m";
      # Todo: resolve conflict
      #right = "i";
      #down = "n";
      #up = "e";

      keybindings =
        let
          modifier = config.modifier;
        in
        lib.mkOptionDefault {
          "${modifier}+l" = "exec ${pkgs.swaylock}/bin/swaylock -k";
        };

      output = {
        HDMI-A-1 = {
          mode = "2560x1440@74.968Hz";
        };
      };

      floating.criteria =
        let
          class = "^Steam$";
        in
        [
          {
            inherit class;
            title = "Friends List";
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
          xkb_layout = "us";
          xkb_variant = "colemak_dh";
        };
      };
      gaps = {
        outer = 25;
        inner = 25;
      };
    };
  };
}

