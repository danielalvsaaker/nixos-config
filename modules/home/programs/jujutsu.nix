{ pkgs, lib, ... }:
{
  programs.jujutsu = {
    enable = true;

    settings = {
      user = {
        name = "danielalvsaaker";
        email = "30574112+danielalvsaaker@users.noreply.github.com";
      };

      ui = {
        pager = ":builtin";
        default-command = "log";
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
