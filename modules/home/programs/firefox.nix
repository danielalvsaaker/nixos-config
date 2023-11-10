{ firefox-addons, ... }:
{
  programs.firefox = {
    enable = true;
    profiles.default = {
      extensions = with firefox-addons; [
        bitwarden
        clearurls
        decentraleyes
        multi-account-containers
        ublock-origin
      ];
    };
  };

  wayland.windowManager.sway.config =
    let
      criteria = {
        app_id = "firefox";
        title = "^Picture-in-Picture$";
      };
    in
    {
      window.commands = [
        {
          command = "floating enable, move position 80 ppt 80 ppt, sticky enable, resize set 20 ppt 20 ppt";
          inherit criteria;
        }
      ];
    };
}
  
