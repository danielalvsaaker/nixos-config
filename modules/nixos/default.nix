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

        # https://github.com/NixOS/nixpkgs/issues/315574
        ({ lib, options, ... }: {
          options.system.nixos.codeName = lib.mkOption { readOnly = false; };
          config.system.nixos.codeName =
            let
              codeName = options.system.nixos.codeName.default;
              renames."Vicuña" = "Vicuna";
            in
              renames."${codeName}" or (throw "Unknown `codeName`: ${codeName}.");
        })
      ];
    };
  };
}
