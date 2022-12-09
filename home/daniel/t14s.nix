{ inputs, ... }: {
  imports = [
    ./global
  ];
  
  home.file.".xinitrc".text = "exec i3";
  programs.firefox.enable = true;
}
