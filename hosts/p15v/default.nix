{ withSystem, inputs, config, ... }:

let
  user = {
    imports = with config.flake.nixosModules; [
      users-daniel
      home-manager
      {
        home-manager.users.daniel = {
          imports = with config.flake.homeManagerModules; [
            profile-cli
          ];
        };
      }
    ];
  };

  configuration = {
    imports = with config.flake.nixosModules; [
      default
    ] ++
    [
      inputs.nixos-wsl.nixosModules.wsl
    ];

    system.stateVersion = "22.11";
    time.timeZone = "Europe/Oslo";

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
        user
      ];
    }
  );
}
