{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bat
    exa
    ripgrep
  ];
}
