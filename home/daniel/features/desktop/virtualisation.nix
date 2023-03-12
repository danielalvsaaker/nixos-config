{ pkgs, ... }:
{
  home.packages = [ pkgs.virt-manager pkgs.dconf ];
}
