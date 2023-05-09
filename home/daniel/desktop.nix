{ inputs, pkgs, ... }:

{
  imports = [
    ./global
    ./features/cli
    ./features/desktop
  ];

  services = {
    mpris-proxy.enable = true;
    playerctld.enable = true;
  };
}
