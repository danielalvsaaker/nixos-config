{ pkgs, ... }:
{
  imports = [
    ./discord.nix
    ./element.nix
    ./firefox.nix
    ./foot.nix
    ./sway.nix
  ];

  home.packages = [ pkgs.jetbrains.rider ];
}
