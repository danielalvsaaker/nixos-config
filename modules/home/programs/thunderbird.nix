{ inputs, ... }:
{
  programs.thunderbird = {
    enable = true;

    profiles.default = {
      isDefault = true;

      userChrome = ''
        @import "${inputs.thunderbird-gnome-theme}/userChrome.css";
      '';

      userContent = ''
        @import "${inputs.thunderbird-gnome-theme}/userContent.css";
      '';

      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "svg.context-properties.content.enabled" = true;
      };
    };
  };
}
