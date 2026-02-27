{ ... }:
{ pkgs, lib, ... }:
{
  programs.jujutsu = {
    enable = true;

    settings = {
      user = {
        name = "danielalvsaaker";
        email = "30574112+danielalvsaaker@users.noreply.github.com";
      };

      signing = {
        behavior = "own";
        backend = "ssh";
        key = "~/.ssh/id_ed25519.pub";
      };

      ui = {
        pager = ":builtin";
        default-command = "log";
        diff-formatter = [
          (lib.getExe pkgs.difftastic)
          "--color=always"
          "$left"
          "$right"
        ];
      };

      merge-tools.mergiraf = {
        program = lib.getExe pkgs.mergiraf;
        merge-args = [ "merge" "$base" "$left" "$right" "-o" "$output" "--fast" ];
        merge-conflict-exit-codes = [ 1 ];
        conflict-marker-style = "git";
      };
    };
  };
}
