{ withSystem, inputs, ... }:

let
  configuration = {
    imports = with inputs.self.homeManagerModules; [
      profiles-cli
    ];

    programs.home-manager.enable = true;
    home = {
      username = "daniel";
      homeDirectory = "/home/daniel";
      stateVersion = "24.05";
    };

    programs.git = {
      userName = "danielalvsaaker";
      userEmail = "30574112+danielalvsaaker@users.noreply.github.com";
    };
  };
in
{
  flake.homeConfigurations.server = withSystem "x86_64-linux" ({ system, pkgs, ... }:
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      modules = [
        configuration
      ];
    }
  );
}
