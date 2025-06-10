{ self }:
{ pkgs, ... }:
{
  programs.firefox = {
    enable = true;

    policies = {
      "BlockAboutAddons" = true;
      "BlockAboutProfiles" = true;
      "DisableFirefoxStudies" = true;
      "DisableSetDesktopBackground" = true;
      "DisableTelemetry" = true;
      "OfferToSaveLogins" = false;
      "PasswordManagerEnabled" = false;
      "PostQuantumKeyAgreementEnabled" = true;
    };

    profiles.default = {
      extensions.packages = with self.inputs.firefox-addons.packages.${pkgs.hostPlatform.system}; [
        bitwarden
        multi-account-containers
        ublock-origin
      ];

      userChrome = ''
        @import "${self.inputs.firefox-gnome-theme}/userChrome.css";
      '';

      userContent = ''
        @import "${self.inputs.firefox-gnome-theme}/userContent.css";
      '';

      settings = {
        "extensions.autoDisableScopes" = 0;
        "extensions.getAddons.showPane" = false;
        "extensions.htmlaboutaddons.recommendations.enabled" = false;
        "dom.private-attribution.submission.enabled" = false;
        "browser.discovery.enabled" = false;
        "browser.translations.automaticallyPopup" = false;
        "widget.use-xdg-desktop-portal.file-picker" = 1;

        # Firefox Gnome theme
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.uidensity" = 0;
        "svg.context-properties.content.enabled" = true;
        "browser.theme.dark-private-windows" = false;
        "widget.gtk.rounded-bottom-corners.enabled" = true;
        "browser.uiCustomization.state" = ''
          {"placements":{"widget-overflow-fixed-list":[],"unified-extensions-area":["_74145f27-f039-47ce-a470-a662b129930a_-browser-action","jid1-bofifl9vbdl2zq_jetpack-browser-action"],"nav-bar":["back-button","forward-button","stop-reload-button","new-tab-button","customizableui-special-spring1","urlbar-container","customizableui-special-spring2","downloads-button","unified-extensions-button","ublock0_raymondhill_net-browser-action","_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action","_testpilot-containers-browser-action"],"toolbar-menubar":["menubar-items"],"TabsToolbar":["tabbrowser-tabs","alltabs-button"],"vertical-tabs":[],"PersonalToolbar":["import-button","personal-bookmarks"]},"seen":["save-to-pocket-button","developer-button","_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action","_74145f27-f039-47ce-a470-a662b129930a_-browser-action","jid1-bofifl9vbdl2zq_jetpack-browser-action","_testpilot-containers-browser-action","ublock0_raymondhill_net-browser-action"],"dirtyAreaCache":["nav-bar","PersonalToolbar","toolbar-menubar","TabsToolbar","unified-extensions-area","vertical-tabs"],"currentVersion":20,"newElementCount":4}
        '';
        "gnomeTheme.hideSingleTab" = true;
      };
    };
  };
}
