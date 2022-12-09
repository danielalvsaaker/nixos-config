{ lib, inputs, outputs, ... }:
{
  imports = {
    inputs.home-manager.nixosModules.home-manager,
  ];

  programs.oksh.enable = true;
  users.defaultUserShell = pkgs.oksh;
  
  fonts.fontconfig.enable = true;
  fonts.fontconfig.defaultFonts.monospace = "IBM Plex Mono";

  home-manager = {
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs outputs; };
  };
}
