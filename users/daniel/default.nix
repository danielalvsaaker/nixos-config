{ config, pkgs, ... }:
{
  users.users.daniel = {
    isNormalUser = true;
    home = "/home/daniel";
    extraGroups = [ "wheel" "audio" "video" ];
    packages = [ pkgs.home-manager ];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE4+o1LN6oSC3EF6SssSWix1E2rITekaC2GtA8Pb3+TL daniel@t14s"
    ];
  };

  programs.fish.enable = true;
}
