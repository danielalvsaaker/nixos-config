{
  nixpkgs.config.allowUnfree = true;

  programs.steam = {
    enable = true;

    remotePlay.openFirewall = true;
    gamescopeSession.enable = true;
  };
}
