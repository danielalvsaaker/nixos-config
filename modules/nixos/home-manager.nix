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
        home.stateVersion = "22.11";
        xdg.enable = true;
      }
    ];
  };
}
