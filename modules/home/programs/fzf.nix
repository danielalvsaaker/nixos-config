{ ... }:
{ pkgs, lib, ... }:
{
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;

    fileWidgetCommand = "${lib.getExe pkgs.fd} --type file";
    fileWidgetOptions = [
      "--preview '${lib.getExe pkgs.bat} --color=always --plain {}'"
    ];

    changeDirWidgetCommand = "${lib.getExe pkgs.fd} --type directory";
    changeDirWidgetOptions = [
      "--preview '${lib.getExe pkgs.eza} --tree --level=2 --color=always {}'"
    ];
  };
}
