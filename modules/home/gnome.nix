{ ... }:
{ pkgs, lib, ... }:

let
  gnome-backgrounds = pkgs.gnome-backgrounds.overrideAttrs rec {
    version = "48.0";
    src = pkgs.fetchurl {
      url = "mirror://gnome/sources/gnome-backgrounds/${lib.versions.major version}/gnome-backgrounds-${version}.tar.xz";
      hash = "sha256-LWuqAR7peATHVh9+HL2NR2PjC1W4gY3aePn3WvuNjQU=";
    };
  };
in
{
  dconf.settings = {
    "org/gnome/desktop/background" = {
      color-shading-type = "solid";
      picture-options = "zoom";
      picture-uri = "file://${gnome-backgrounds}/share/backgrounds/gnome/ring-l.jxl";
      picture-uri-dark = "file://${gnome-backgrounds}/share/backgrounds/gnome/ring-d.jxl";
    };

    "org/gnome/desktop/calendar" = {
      show-weekdate = true;
    };

    "org/gnome/desktop/screensaver" = {
      restart-enabled = true;
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };

    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "appindicatorsupport@rgcjonas.gmail.com"
      ];
    };

    "org/gnome/mutter" = {
      dynamic-workspaces = true;
      edge-tiling = true;
      workspaces-only-on-primary = true;
    };
  };
}
