{ inputs, ... }:
{
  imports = with inputs.self.nixosModules; [
    users-daniel
    home-manager
    {
      home-manager.users.daniel = { pkgs, ... }: {
        imports = with inputs.self.homeManagerModules; [
          profiles-desktop
          profiles-cli
        ];

        home.packages = [
          pkgs.jetbrains.rider
        ];

        programs.git = {
          userName = "danielalvsaaker";
          userEmail = "30574112+danielalvsaaker@users.noreply.github.com";
        };
      };
    }
  ];
}
