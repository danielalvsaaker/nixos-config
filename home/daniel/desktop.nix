{ inputs, pkgs, ... }:

{
  imports = [
    ./global
    ./features/cli
    ./features/desktop
  ];

  home.packages = [
    pkgs.jetbrains.rider
  ];

  services = {
    mpris-proxy.enable = true;
    playerctld.enable = true;
  };
}
