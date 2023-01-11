{ pkgs, ... }:
{
  home.packages = with pkgs; [
    exa
    fd
    ripgrep
  ];
}
