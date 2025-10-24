{ pkgs, ... }:
{
  programs.helix = {
    enable = true;
    defaultEditor = true;

    extraPackages = [
      pkgs.wl-clipboard
    ];

    settings = {
      theme = {
        dark = "adwaita-dark";
        light = "adwaita-light";
      };

      editor = {
        line-number = "relative";
        true-color = true;
        inline-diagnostics.cursor-line = "warning";
      };
    };
  };
}
