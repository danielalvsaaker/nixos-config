{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    
    extraConfig = ''
      inoremap øø {
      inoremap ææ }
    '';
  };
}
