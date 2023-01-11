{
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
    fileWidgetCommand = "fd --type f";
    defaultOptions = [
      "--preview 'bat {}'"      
    ];
  };
}
