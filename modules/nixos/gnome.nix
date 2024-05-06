{ pkgs, lib, ... }:
{
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    updateDbusEnvironment = true;
  };
  services.libinput.enable = true;

  services.gnome.core-shell.enable = lib.mkForce false;
  services.gnome.core-utilities.enable = lib.mkForce false;
  services.gnome.core-os-services.enable = lib.mkForce false;

  programs.dconf.enable = true;
  security.polkit.enable = true;
  services.accounts-daemon.enable = true;

  xdg.mime.enable = true;
  xdg.icons.enable = true;

  xdg.portal.extraPortals = [
    pkgs.xdg-desktop-portal-gnome
    (pkgs.xdg-desktop-portal-gtk.override {
      buildPortalsInGnome = false;
    })
  ];

  environment = {
    systemPackages = [ pkgs.sound-theme-freedesktop ];
    pathsToLink = [ "/share " ];
  };
}
