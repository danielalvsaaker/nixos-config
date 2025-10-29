{ self }:
{ pkgs, lib, ... }:
{
  home.packages = [
    self.inputs.ki-editor.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  xdg.configFile."ki/config.json".text = builtins.toJSON {
    keyboard_layout = "COLEMAK-DH";
    theme = "Dracula";

    languages = {
      c_sharp = {
        lsp_command = {
          command = {
            command = lib.getExe pkgs.roslyn-ls;
            arguments = [ "--stdio" "--autoLoadProjects" ];
          };
        };
      };
    };
  };
}
