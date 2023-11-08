{ inputs, pkgs, ... }:

{
  imports = [
    ./features/cli
  ];

  home.packages = [
    pkgs.jetbrains.rider
  ];

  services = {
    mpris-proxy.enable = true;
    playerctld.enable = true;
  };
}
