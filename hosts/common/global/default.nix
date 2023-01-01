{ inputs, outputs, ... }:
{
  imports = [
    ./fish.nix
  ];

  home-manager = {
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs outputs; };
  };

  nixpkgs.config.allowUnfree = true;
}
