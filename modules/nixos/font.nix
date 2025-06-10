{ ... }:
{ pkgs, ... }:
{
  fonts = {
    enableDefaultPackages = true;
    fontconfig.defaultFonts = {
      monospace = [ "BlexMono Nerd Font Mono" ];
    };

    packages = [
      pkgs.nerd-fonts.blex-mono
    ];
  };
}
