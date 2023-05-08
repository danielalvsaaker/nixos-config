{ pkgs, ... }:
{
  programs.steam = with pkgs; {
    enable = true;
    remotePlay.openFirewall = true;
    package = steam.override {
      extraProfile = ''
        export GSETTINGS_SCHEMA_DIR="${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}/glib-2.0/schemas/"
      '';
    };
  };
  programs.gamemode.enable = true;
}
