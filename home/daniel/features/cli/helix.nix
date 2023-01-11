{
  programs.helix = {
    enable = true;
    settings = {
      theme = "fleet_dark";
      editor = {
        line-number = "relative";
        true-color = true;
      };
      keys.normal = {
        m = "move_char_left";
        n = "move_line_down";
        e = "move_line_up";
        i = "move_char_right";
        u = "insert_mode";
        U = "insert_at_line_start";
        y = "open_below";
        Y = "open_above";
        j = "yank";
        l = "undo";
        L = "redo";
        f = "move_next_word_end";
        F = "move_next_long_word_end";
      };
    };
  };
}
