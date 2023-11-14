{ withSystem, inputs, ... }:

let
  user = {
    imports = with inputs.self.nixosModules; [
      users-daniel
      home-manager
      {
        home-manager.users.daniel = {
          imports = with inputs.self.homeManagerModules; [
            profiles-cli
          ];

          programs.git = {
            userName = "danielalvsaaker";
            userEmail = "30574112+danielalvsaaker@users.noreply.github.com";
          };
        };
      }
    ];
  };

  configuration = {
    imports = with inputs.self.nixosModules; [
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

      specialArgs = { inherit inputs; };

      modules = [
        configuration
        user
      ];
    }
  );
}
