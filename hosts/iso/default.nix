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
      sway
      plymouth
      gnome
    ] ++
    [
      inputs.nixos-generators.nixosModules.install-iso
    ];

    system.stateVersion = "24.11";
    time.timeZone = "Europe/Oslo";
  };
in
{
  flake.nixosConfigurations.iso = withSystem "x86_64-linux" ({ system, ... }:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;

      specialArgs = { inherit inputs; };

      modules = [
        configuration
        user
      ];
    });
}
