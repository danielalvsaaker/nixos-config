{ inputs, pkgs, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      firefox-addons = inputs.firefox-addons.packages.${pkgs.hostPlatform.system};
    };

    sharedModules = [
      {
        home.stateVersion = "22.11";
        xdg.enable = true;
      }
    ];
  };
}
