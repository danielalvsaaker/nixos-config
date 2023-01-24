{ pkgs, config, ... }:
{
  programs.home-manager.enable = true;

  home = {
    username = "daniel";
    homeDirectory = "/home/${config.home.username}";
    stateVersion = "22.11";
  };
  xdg.enable = true;
}
