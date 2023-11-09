{ inputs, ... }:
{
  imports = with inputs.self.nixosModules; [
    users-daniel
    home-manager
    {
      home-manager.users.daniel = {
        imports = with inputs.self.homeManagerModules; [
          profile-desktop
          profile-cli
        ];
      };
    }
  ];
}
