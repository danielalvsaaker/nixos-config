{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "IBMPlexMono" ]; })
  ];

  programs.home-manager.enable = true;

  home = {
    username = "daniel";
    homeDirectory = "/home/${config.home.username}";
    stateVersion = "22.11";
  };
}
