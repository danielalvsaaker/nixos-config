{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , nixos-hardware
    , ...
    }@inputs:
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;

      nixosConfigurations = {
        t14s = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = (with nixos-hardware.nixosModules; [
            lenovo-thinkpad-t14s-amd-gen1
          ]) ++
          [
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

        desktop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = (with nixos-hardware.nixosModules; [
            common-cpu-amd
            common-cpu-amd-pstate
            common-gpu-amd
            common-pc-ssd
          ]) ++
          [
            ./hosts/desktop
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.daniel = import ./home/daniel/desktop.nix;
                extraSpecialArgs = { inherit inputs; };
              };
            }
          ];
        };

        p15v = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/p15v
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.daniel = import ./home/daniel/p15v.nix;
                extraSpecialArgs = { inherit inputs; };
              };
            }
          ];
          specialArgs = { inherit (inputs) nixos-wsl; };
        };
      };
    };
}
