{ ... }:
{ pkgs, lib, ... }:

let
  core-os-services = {
    services.gnome.core-os-services.enable = true;

    services.dleyna.enable = false;
    xdg.portal.xdgOpenUsePortal = true;
  };

  core-shell = {
    services.gnome.core-shell.enable = true;

    services.gnome.gnome-browser-connector.enable = false;
    services.gnome.gnome-initial-setup.enable = false;
    services.gnome.gnome-user-share.enable = false;
    services.gnome.rygel.enable = false;
    services.avahi.enable = false;
    environment.gnome.excludePackages = [ pkgs.gnome-tour ];
  };

  core-apps = {
    services.gnome.core-apps.enable = true;

    environment.gnome.excludePackages = [
      pkgs.epiphany
      pkgs.gnome-console
      pkgs.gnome-logs
      pkgs.geary
      pkgs.totem
      pkgs.yelp
      pkgs.seahorse
    ];
  };

in
lib.foldl' lib.recursiveUpdate
{
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  environment = {
    systemPackages = [
      pkgs.gnomeExtensions.appindicator
      pkgs.resources
      pkgs.key-rack
    ];
  };
} [
  core-shell
  core-os-services
  core-apps
]
