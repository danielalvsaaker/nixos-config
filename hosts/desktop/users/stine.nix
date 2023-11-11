{ inputs, ... }:
{
  imports = with inputs.self.nixosModules; [
    users-stine
    home-manager
    {
      home-manager.users.stine = { pkgs, ... }: {
        imports = with inputs.self.homeManagerModules; [
          programs-firefox
        ];

        home.packages = [ pkgs.minecraft ];
      };
    }
  ];
}
