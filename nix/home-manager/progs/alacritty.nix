{
  shell.program = "fish";
  env.TERM = "xterm-256color";

  window = {
    decorations = "none";
    opacity = 0.85;

    padding = {
      x = 10;
      y = 10;
    };

    dimensions = {
      columns = 80;
      lines = 40;
    };
  };

  scrolling = {
    history = 1000;
    multiplier = 3;
  };

  font = {
    size = 13;

    normal = {
      family = "JetBrains Mono Nerd Font";
      style = "Regular";
    };

    bold = {
      family = "JetBrains Mono Nerd Font";
      style = "Bold";
    };

    italic = {
      family = "JetBrains Mono Nerd Font";
      style = "Italic";
    };

    offset.y = 0;
    glyph_offset.y = 0;
  };

  colors = {
    primary = {
      background = "0x131621";
      foreground = "0xa6accd";
    };

    cursor = {
      text = "CellBackground";
      cursor = "CellForeground";
    };

    search = {
      matches = {
        foreground = "0x1b1e28";
        background = "0xadd7ff";
      };

      focused_match = {
        foreground = "0x1b1e28";
        background = "0xadd7ff";
      };
    };

    selection = {
      text = "CellForeground";
      background = "0x303340";
    };

    vi_mode_cursor = {
      text = "CellBackground";
      cursor = "CellForeground";
    };

    normal = {
      black = "0x1b1e28";
      red = "0xd0679d";
      green = "0x5de4c7";
      yellow = "0xfffac2";
      blue = "#435c89";
      magenta = "0xfcc5e9";
      cyan = "0xadd7ff";
      white = "0xffffff";
    };

    bright = {
      black = "0xa6accd";
      red = "0xd0679d";
      green = "0x5de4c7";
      yellow = "0xfffac2";
      blue = "0xadd7ff";
      magenta = "0xfae4fc";
      cyan = "0x89ddff";
      white = "0xffffff";
    };
  };

  cursor = {
    style = "Underline";
    vi_mode_style = "Underline";
  };
}
