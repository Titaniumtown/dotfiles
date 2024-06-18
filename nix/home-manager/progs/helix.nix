{ pkgs, ... }:
{
  enable = true;
  package = pkgs.helix;
  settings = {
    theme = "my_theme";
    editor = {
      cursor-shape = {
        insert = "bar";
        normal = "block";
        select = "underline";
      };

      file-picker = {
        hidden = false;
      };

      #wrapping!!
      soft-wrap.enable = true;
    };
  };

  languages = {
    language = [
      {
        name = "rust";
        auto-format = true;
      }
    ];
  };

  themes = {
    #modified fleet_dark theme
    my_theme =
      let
        white = "#ffffff";
        gray-120 = "#d1d1d1";
        gray-110 = "#c2c2c2";
        gray-100 = "#a0a0a0";
        gray-90 = "#898989";
        gray-80 = "#767676";
        gray-70 = "#5d5d5d";
        gray-60 = "#484848";
        gray-50 = "#383838";
        gray-40 = "#333333";
        gray-30 = "#2d2d2d";
        gray-20 = "#292929";
        gray-10 = "#181818";
        black = "#000000";
        blue-110 = "#6daaf7";
        blue-100 = "#4d9bf8";
        blue-90 = "#3691f9";
        blue-80 = "#1a85f6";
        blue-70 = "#0273eb";
        blue-60 = "#0c6ddd";
        blue-50 = "#195eb5";
        blue-40 = "#194176";
        blue-30 = "#163764";
        blue-20 = "#132c4f";
        blue-10 = "#0b1b32";
        red-80 = "#ec7388";
        red-70 = "#ea4b67";
        red-60 = "#d93953";
        red-50 = "#ce364d";
        red-40 = "#c03248";
        red-30 = "#a72a3f";
        red-20 = "#761b2d";
        red-10 = "#390813";
        green-50 = "#4ca988";
        green-40 = "#3ea17f";
        green-30 = "#028764";
        green-20 = "#134939";
        green-10 = "#081f19";
        yellow-60 = "#f8ab17";
        yellow-50 = "#e1971b";
        yellow-40 = "#b5791f";
        yellow-30 = "#7c511a";
        yellow-20 = "#5a3a14";
        yellow-10 = "#281806";
        purple-20 = "#c07bf3";
        purple-10 = "#b35def";

        blue = "#87C3FF";
        blue-light = "#ADD1DE";
        coral = "#CC7C8A";
        cyan = "#82D2CE";
        cyan-dark = "#779E9E";
        lime = "#A8CC7C";
        orange = "#E09B70";
        pink = "#E394DC";
        violet = "#AF9CFF";
        yellow = "#EBC88D";
      in
      {
        "attribute" = lime;
        "type" = blue;
        "type.return" = blue-light;
        "type.parameter" = blue-light;
        "constructor" = yellow;
        "constant" = violet;
        "constant.builtin.boolean" = cyan;
        "constant.character" = yellow;
        "constant.character.escape" = cyan;
        "constant.numeric" = yellow;
        "string" = pink;
        "string.regexp" = cyan;
        "string.special" = {
          fg = yellow;
          modifiers = [ "underlined" ];
        }; # .path / .url / .symbol

        "comment" = gray-90; # .line
        # "comment.block" = {} # .documentation
        "variable" = gray-120; # .builtin
        "variable.builtin" = {
          fg = coral;
        };
        # "variable.other" = {} # .member
        "variable.other.member" = violet;
        "label" = yellow;
        "keyword" = cyan; # .operator / .directive / .function
        "function" = yellow;
        "function.declaration" = "#EFEFEF";
        "function.macro" = lime;
        "function.builtin" = lime;
        "function.special" = lime;
        #"function.declaration.method" = { fg = "lightest", modifiers = ["bold"] } #depends on #4892
        "tag" = blue;
        "special" = lime;
        "namespace" = blue;

        # used in theming
        # "markup" = {} # .normal / .quote / .raw
        # "markup.normal" = {} # .completion / .hover
        "markup.bold" = {
          modifiers = [ "bold" ];
        };
        "markup.italic" = {
          modifiers = [ "italic" ];
        };
        "markup.strikethrough" = {
          modifiers = [ "crossed_out" ];
        };
        "markup.heading" = {
          fg = cyan;
          modifiers = [ "bold" ];
        }; # .marker / .1 / .2 / .3 / .4 / .5 / .6
        "markup.list" = pink; # .unnumbered / .numbered
        "markup.list.numbered" = cyan;
        "markup.list.unnumbered" = cyan;
        # "markup.link" = "green"
        "markup.link.url" = {
          fg = pink;
          modifiers = [
            "italic"
            "underlined"
          ];
        };
        "markup.link.text" = cyan;
        "markup.link.label" = purple-20;
        "markup.quote" = pink;
        "markup.raw" = pink;
        "markup.raw.inline" = cyan; # .completion / .hover
        "markup.raw.block" = "#EB83E2";

        "diff.plus" = green-50;
        "diff.minus" = red-50;
        "diff.delta" = blue-80;

        # ui specific
        # "ui.background" = { bg = gray-10; }; # .separator
        "ui.background" = { };
        "ui.statusline" = {
          fg = gray-120;
          bg = gray-20;
        }; # .inactive / .normal / .insert / .select
        "ui.statusline.normal" = {
          fg = gray-120;
          bg = gray-20;
        };
        "ui.statusline.inactive" = {
          fg = gray-90;
        };
        "ui.statusline.insert" = {
          fg = gray-20;
          bg = blue-90;
        };
        "ui.statusline.select" = {
          fg = gray-20;
          bg = yellow-60;
        };

        "ui.cursor" = {
          modifiers = [ "reversed" ];
        }; # .insert / .select / .match / .primary
        "ui.cursor.match" = {
          bg = blue-30;
        }; # .insert / .select / .match / .primary
        "ui.selection" = {
          bg = gray-50;
        }; # .primary
        "ui.selection.primary" = {
          bg = blue-40;
        };

        "ui.cursorline" = {
          bg = gray-20;
        };
        "ui.linenr" = gray-70;
        "ui.linenr.selected" = gray-110;

        "ui.popup" = {
          fg = gray-120;
          bg = gray-20;
        }; # .info
        "ui.window" = {
          fg = gray-50;
        };
        "ui.help" = {
          fg = gray-120;
          bg = gray-20;
        };
        "ui.menu" = {
          fg = gray-120;
          bg = gray-20;
        }; # .selected
        "ui.menu.selected" = {
          fg = white;
          bg = blue-40;
        }; # .selected
        # Calculated as #ffffff with 30% opacity
        "ui.menu.scroll" = {
          fg = "#dfdfdf";
        };

        "ui.text" = gray-120; # .focus / .info
        "ui.text.focus" = {
          fg = white;
          bg = blue-40;
        };

        "ui.virtual" = gray-90; # .whitespace
        "ui.virtual.inlay-hint" = {
          fg = gray-70;
        };
        "ui.virtual.ruler" = {
          bg = gray-20;
        };

        "hint" = gray-80;
        "info" = "#A366C4";
        "warning" = "#FACb66";
        "error" = "#FF5269";

        "diagnostic.hint" = {
          underline = {
            color = gray-80;
            style = "line";
          };
        };
        "diagnostic.info" = {
          underline = {
            color = "#A366C4";
            style = "line";
          };
        };
        "diagnostic.warning" = {
          underline = {
            color = "#FACB66";
            style = "line";
          };
        };
        "diagnostic.error" = {
          underline = {
            color = "#FF5269";
            style = "line";
          };
        };
        "diagnostic.unnecessary" = {
          modifiers = [ "dim" ];
        };
        "diagnostic.deprecated" = {
          modifiers = [ "crossed_out" ];
        };
      };
  };
}
