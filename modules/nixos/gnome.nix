{ pkgs, lib, ... }:
{
  services.xserver = {
    enable = true;

    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    updateDbusEnvironment = true;
    excludePackages = [ pkgs.xterm ];
  };
  services.libinput.enable = true;

  services.gnome = {
    core-utilities.enable = lib.mkForce false;
    core-os-services.enable = lib.mkForce false;

    gnome-remote-desktop.enable = false;
    rygel.enable = false;
    gnome-keyring.enable = true;
  };
  environment.gnome.excludePackages = [ pkgs.gnome-tour ];
  services.avahi.enable = false;

  programs.dconf.enable = true;
  security.polkit.enable = true;
  services.accounts-daemon.enable = true;
  services.upower.enable = true;

  services.gnome.sushi.enable = true;
  programs.evince.enable = true;

  xdg.mime.enable = true;
  xdg.icons.enable = true;

  xdg.portal = {
    enable = true;

    configPackages = [ pkgs.gnome.gnome-session ];
    extraPortals = [
      pkgs.xdg-desktop-portal-gnome
      (pkgs.xdg-desktop-portal-gtk.override {
        buildPortalsInGnome = false;
      })
    ];
  };

  environment = {
    systemPackages = [
      pkgs.gnome.nautilus
      pkgs.loupe
      pkgs.sound-theme-freedesktop
      pkgs.gnomeExtensions.appindicator
    ];
    pathsToLink = [ "/share" ];
  };
  services.udev.packages = [ pkgs.gnome.gnome-settings-daemon ];
}
