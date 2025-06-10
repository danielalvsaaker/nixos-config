{ ... }:
{
  programs.starship = {
    enable = true;
    enableFishIntegration = true;

    settings = {
      add_newline = false;
      right_format = "$time";

      cmd_duration.disabled = true;
      line_break.disabled = true;
      package.disabled = true;
      rust.disabled = true;

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
