{ inputs, pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    profiles.default = {
      extensions = with inputs.firefox-addons.packages.${pkgs.hostPlatform.system}; [
        bitwarden
        clearurls
        decentraleyes
        multi-account-containers
        ublock-origin
      ];

      userChrome = ''
        @import "${inputs.firefox-gnome-theme}/userChrome.css";
      '';

      userContent = ''
        @import "${inputs.firefox-gnome-theme}/userContent.css";
      '';

      settings = {
        # Firefox Gnome theme
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.uidensity" = 0;
        "svg.context-properties.content.enabled" = true;
        "browser.theme.dark-private-windows" = false;
        "widget.gtk.rounded-bottom-corners.enabled" = true;
      };
    };
  };
}
