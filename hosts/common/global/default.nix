{ lib, inputs, outputs, ... }:
{
  imports = {
    inputs.home-manager.nixosModules.home-manager,
    ];

    fonts.fontconfig.enable = true;
    fonts.fontconfig.defaultFonts.monospace = "IBM Plex Mono";

    home-manager = {
      useUserPackages = true;
      extraSpecialArgs = { inherit inputs outputs; };
    };
  }
