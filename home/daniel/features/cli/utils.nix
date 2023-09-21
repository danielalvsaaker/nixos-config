{ pkgs, ... }:
{
  home.packages = with pkgs; [
    eza
    fd
    ripgrep
  ];
}
