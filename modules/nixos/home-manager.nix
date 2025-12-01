{ self, ... }:
{ inputs, ... }:
{
  imports = [
    self.inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };

    sharedModules = [
      {
        xdg.enable = true;
      }
    ];
  };
}
