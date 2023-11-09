{ inputs, ... }:
{
  imports = with inputs.self.nixosModules; [
    users-daniel
    home-manager
    {
      home-manager.users.daniel = { pkgs, ... }: {
        imports = with inputs.self.homeManagerModules; [
          profile-desktop
          profile-cli
        ];

        home.packages = [
          pkgs.jetbrains.rider
        ];
      };
    }
  ];
}
