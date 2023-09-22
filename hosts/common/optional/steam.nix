{ pkgs, ... }:
{
  programs.steam = with pkgs; {
    enable = true;
    remotePlay.openFirewall = true;
  };
}
