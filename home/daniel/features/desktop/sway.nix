{
  wayland.windowManager.sway = {
    enable = true;
    config = {
      modifier = "Mod4";
      # Use kitty as default terminal
      terminal = "foot";
      startup = [
        # Launch Firefox on start
        { command = "firefox"; }
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

