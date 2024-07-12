{ lib, pkgs, ... }:
{
  home.packages = [ pkgs.blackbox-terminal ];

  dconf.settings."com/raggesilver/BlackBox" = with lib.hm.gvariant; {
    "font" = "Monospace 10";
    "terminal-padding" = mkTuple (lib.replicate 4 (mkUint32 5));
    "theme-dark" = "Dracula";
  };
}
