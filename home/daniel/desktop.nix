{ inputs, pkgs, ... }:

{
  imports = [
    ./global
    ./features/cli
    ./features/desktop
 ];
}
