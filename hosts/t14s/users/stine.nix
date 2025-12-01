{ inputs, ... }:
{
  imports = with inputs.self.nixosModules; [
    users-stine
    home-manager
  ];

  home-manager.users.stine = {
    imports = with inputs.self.homeManagerModules; [
      programs-firefox
    ];

    home.stateVersion = "25.11";
  };
}
