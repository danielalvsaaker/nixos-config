{
  flake.nixosModules.font = { pkgs, ... }:
    {
      fonts = {
        enableDefaultPackages = true;
        fontconfig.defaultFonts = {
          monospace = [ "BlexMono Nerd Font Mono" ];
        };

        packages = [
          (pkgs.nerdfonts.override { fonts = [ "IBMPlexMono" ]; })
        ];
      };
    };
}
