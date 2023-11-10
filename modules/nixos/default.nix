{ config, ... }:

let
  modules = config.flake.lib.modules.generateModules ./.;
in
{
  flake.nixosModules = modules // {
    default = {
      imports = [
        config.flake.nixosModules.font
        config.flake.nixosModules.nix
      ];
    };
  };
}
