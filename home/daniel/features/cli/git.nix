{
  programs.git = {
    enable = true;
    userName = "Daniel Alvsåker";
    userEmail = "daniel.alvsaaker@protonmail.com";

    aliases = {
      ap = "add --patch";
    };

    delta = {
      enable = true;
      options = {
        syntax-theme = "Dracula";
        navigate = true;
        line-numbers = true;
      };
    };

    extraConfig = {
      pull.rebase = true;
      core.editor = "hx";
    };
  };
}
