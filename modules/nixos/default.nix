{ self, config, lib, ... }:

let
  modules = config.flake.lib.modules.generateModules ./.;
  modules' = builtins.mapAttrs
    (name: module:
      lib.modules.importApply module { inherit self; }
    )
    modules;
in
{
  flake.nixosModules = modules' // {
    default = {
      imports = [
        config.flake.nixosModules.font
        config.flake.nixosModules.nix
      ];
    };
  };
}
