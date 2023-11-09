{ config, ... }:

let
  modules = config.flake.lib.modules.generateModules ./.;
in
{
  # imports = [
  #   ./bluetooth.nix
  #   ./font.nix
  #   ./home-manager.nix
  #   ./kernel.nix
  #   ./nix.nix
  #   ./steam.nix
  #   ./users/daniel.nix
  # ];

  flake.nixosModules = modules // {
    default = {
      imports = [
        config.flake.nixosModules.font
        config.flake.nixosModules.nix
      ];
    };
  };
}
