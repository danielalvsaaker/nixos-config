{ ... }:
{ pkgs, lib, ... }:
{
  programs.git = {
    enable = true;

    settings.aliases = {
      ap = "add --patch";
      an = "commit --amend --no-edit";
    };

    attributes = [
      "*.java merge=mergiraf"
      "*.rs merge=mergiraf"
      "*.go merge=mergiraf"
      "*.js merge=mergiraf"
      "*.jsx merge=mergiraf"
      "*.json merge=mergiraf"
      "*.yml merge=mergiraf"
      "*.yaml merge=mergiraf"
      "*.html merge=mergiraf"
      "*.htm merge=mergiraf"
      "*.xhtml merge=mergiraf"
      "*.xml merge=mergiraf"
      "*.c merge=mergiraf"
      "*.cc merge=mergiraf"
      "*.h merge=mergiraf"
      "*.cpp merge=mergiraf"
      "*.hpp merge=mergiraf"
      "*.cs merge=mergiraf"
      "*.dart merge=mergiraf"
    ];

    settings = {
      pull.rebase = true;
      push.autoSetupRemote = true;
      core.editor = lib.getExe pkgs.helix;

      merge.mergiraf.driver = "${lib.getExe pkgs.mergiraf} merge --git %O %A %B -s %S -x %X -y %Y -p %P";
    };
  };

    programs.delta = {
      enable = true;
      options = {
        navigate = true;
        line-numbers = true;
      };
    };

}
