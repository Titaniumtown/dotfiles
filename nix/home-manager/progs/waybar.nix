{
  enable = true;
  settings = {
    mainBar = {
      layer = "top";
      position = "top";
      spacing = 0;
      height = 45;
      modules-left = [ ];
      #put the clock in the center
      modules-center = [ "clock" ];

      #modules left->right on the top right of the screen
      modules-right = [
        "tray"
        "backlight"
        "pulseaudio"
        "battery"
      ];

      tray = {
        spacing = 16;
      };

      #clock
      clock = {
        "tooltip-format" = "<tt>{calendar}</tt>";
        "format-alt" = "  {:%a, %d %b %Y}";
        format = "󰥔  {:%I:%M %p}";
      };

      #it's **called** pulseaudio, but it's just audio in general, I'm using pipewire
      pulseaudio = {
        format = "{icon} {volume}%";
        "format-bluetooth" = "󰂰";
        nospacing = 1;
        "tooltip-format" = "Volume : {volume}%";
        "format-muted" = "󰝟";
        "format-icons" = {
          "headphone" = "";
          "default" = [
            "󰖀"
            "󰕾"
            ""
          ];
        };
        "on-click" = "pavucontrol";
        "scroll-step" = 1;
      };

      #this config is for my laptop, so show a battery icon and stats
      battery = {
        format = "{capacity}% {icon}";
        "format-icons" = {
          "charging" = [
            "󰢜"
            "󰂆"
            "󰂇"
            "󰂈"
            "󰢝"
            "󰂉"
            "󰢞"
            "󰂊"
            "󰂋"
            "󰂅"
          ];
          "default" = [
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
        };
        "format-full" = "󰁹 ";
        interval = 10;
        states = {
          warning = 20;
          critical = 10;
        };
      };
    };
  };
  style = ''
    * {
      border: none;
      border-radius: 0;
      min-height: 0;
      font-family: "FiraCode Nerd Font Mono";
      color: #FCFCFC;
      font-weight: 700;
    }

    window#waybar {
      background-color: transparent;
      transition-property: background-color;
      transition-duration: 0.5s;
      border-radius: 15px;
      font-size: 20px;
    }

    .modules-center, .modules-right {
      border-radius: 15px;
      background-color: #040409;
      padding: 0px 0px;
    }

    window#waybar.hidden {
      opacity: 0.5;
    }

    #battery,
    #backlight,
    #pulseaudio,
    #network,
    #clock,
    #tray,
    #backlight {
      border-radius: 9px;
      margin: 6px 3px;
      padding: 6px 12px;
      background-color: #101012;
      color: #ECECEC;
    }

    #tray menu {
      background-color: #101012;
      color: #ECECEC;
    }

    @keyframes blink {
      to {
        background-color: #f38ba8;
        color: #181825;
      }
    }

    #battery.warning,
    #battery.critical,
    #battery.urgent {
      background-color: #ff0048;
      color: #181825;
      animation-name: blink;
      animation-duration: 0.5s;
      animation-timing-function: linear;
      animation-iteration-count: infinite;
      animation-direction: alternate;
    }

    #battery.charging {
      background-color: #101012;
      color: #ECECEC;
      animation: none;
    }

    tooltip {
      border-radius: 8px;
      padding: 15px;
      background-color: #101012;
      color: #ECECEC;
      opacity: 0.8;
    }

    tooltip label {
      padding: 5px;
      background-color: #101012;
      color: #ECECEC;
      opacity: 0.8;
    }
  '';
}
