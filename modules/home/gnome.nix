{ pkgs, ... }:
{
  dconf.settings = {
    "org/gnome/desktop/background" = {
      color-shading-type = "solid";
      picture-options = "zoom";
      picture-uri = "file://${pkgs.gnome-backgrounds}/share/backgrounds/gnome/ring-l.jxl";
      picture-uri-dark = "file://${pkgs.gnome-backgrounds}/share/backgrounds/gnome/ring-d.jxl";
    };

    "org/gnome/desktop/calendar" = {
      show-weekdate = true;
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
