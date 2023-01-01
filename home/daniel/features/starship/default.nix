{
  programs.starship = {
    enable = true;
    enableFishIntegration = true;

    settings = {
      right_format = "$time";

      line_break.disabled = true;
      package.disabled = true;
      cmd_duration.disabled = true;

      time = {
        disabled = false;
        style = "bold bright-black";
        format = "[$time]($style) ";
      };

      username = {
        show_always = true;
        format = "[$user]($style)";
      };

      hostname = {
        format = "[@$hostname]($style)";
        ssh_only = true;
      };

      directory = {
        format = "[:$path]($style) ";
      };
    };
  };
}
