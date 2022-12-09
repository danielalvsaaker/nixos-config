{
  programs.git = {
    enable = true;
    userName = "Daniel Alvsåker";
    userEmail = "daniel.alvsaaker@protonmail.com";
    
    extraConfig = {
      pull.rebase = true;
    };
  };
}
