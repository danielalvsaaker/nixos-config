{ inputs, ... }:
{
  flake.nixosModules.home-manager = { system, ...}: {
    imports = [
      inputs.home-manager.nixosModules.home-manager
    ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {
        firefox-addons = inputs.firefox-addons.packages.${system};
      };
    };
  };
}
