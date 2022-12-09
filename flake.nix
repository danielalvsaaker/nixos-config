{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    wm = {
      url = "git+ssh://git@github.com/danielalvsaaker/wm";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
  {
    nixosConfigurations = {
      t14s = nixpkgs.lib.nixosSystem {
	      system = "x86_64-linux";
	      modules = [
	        ./hosts/t14s
	        home-manager.nixosModules.home-manager
	        {
	          home-manager = {
		  	      useGlobalPkgs = true;
	          	useUserPackages = true;
	          	users.daniel = import ./home/daniel/t14s.nix;
			        extraSpecialArgs = { inherit inputs; };
		        };
	        }
	      ];
      };
    };
  };
}
