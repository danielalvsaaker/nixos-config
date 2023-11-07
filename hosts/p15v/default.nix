{ withSystem, inputs, ... }:

let
  configuration = {
    imports = [
      ../common/global
    ];

    wsl = {
      enable = true;
      defaultUser = "daniel";
      wslConf.automount.root = "/mnt";
      nativeSystemd = true;
    };
  };
in
{
  flake.nixosConfigurations.p15v = withSystem "x86_64-linux" ({ system, ... }:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;

      specialArgs = { inherit inputs system; };

      modules = [
        configuration
        inputs.nixos-wsl.nixosModules.wsl
        inputs.self.nixosModules.user-daniel
        inputs.self.nixosModules.home-manager
        {
          home-manager.users.daniel = import ../../home/daniel/p15v.nix;
        }
      ];
    }
  );
}
