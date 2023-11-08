{ inputs, ... }:
{
  flake.nixosModules.home-manager = { system, ... }: {
    imports = [
      inputs.home-manager.nixosModules.home-manager
    ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {
        firefox-addons = inputs.firefox-addons.packages.${system};
      };

      sharedModules = [
        {
          home.stateVersion = "22.11";
          xdg.enable = true;
        }
      ];
    };
  };
}
