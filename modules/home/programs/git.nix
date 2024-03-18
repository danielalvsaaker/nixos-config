{ pkgs, lib, ... }:
{
  programs.git = {
    enable = true;

    aliases = {
      ap = "add --patch";
    };

    delta = {
      enable = true;
      options = {
        syntax-theme = "Dracula";
        navigate = true;
        line-numbers = true;
      };
    };

    extraConfig = {
      pull.rebase = true;
      push.autoSetupRemote = true;
      core.editor = lib.getExe pkgs.helix;
    };
  };
}
