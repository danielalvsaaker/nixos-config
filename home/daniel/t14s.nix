{ inputs, ... }: {
  imports = [
    ./global
  ];

  home.file.".xinitrc".text = "exec wm";
  programs.firefox.enable = true;

  home.packages = [ inputs.wm.defaultPackage.x86_64-linux ];
}
