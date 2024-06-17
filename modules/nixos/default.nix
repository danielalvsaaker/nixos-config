{ config, ... }:

let
  modules = config.flake.lib.modules.generateModules ./.;
in
{
  flake.nixosModules = modules // {
    default = { lib, ... }: {
      imports = [
        config.flake.nixosModules.font
        config.flake.nixosModules.nix
      ];
    };
  };
}
