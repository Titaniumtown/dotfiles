{
  config,
  pkgs,
  inputs,
  ...
}:
{
  home.username = "primary";
  home.homeDirectory = "/home/primary";

  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    librewolf

    gnome.gnome-calculator # calculator
    gnome.nautilus # file manager
    gnome.eog # image viewer

    #text editor of choice
    helix

    #hex viewer
    hexyl

    #productivity stuff
    libreoffice
    hunspell # auto correct
    hunspellDicts.en_US

    #rust stuff
    rustc
    rustfmt
    cargo
    rust-analyzer

    #video and audio downloading
    parabolic

    #soulseek client
    nicotine-plus

    #for website generation
    hugo

    #dark web browsing deep web browsing
    tor-browser

    #audio editing
    audacity

    #google java format my beloved
    google-java-format

    #java lsp language server
    jdt-language-server

    #provides volumectl
    avizo

    #fonts
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    nerdfonts # 🤓
    jetbrains-mono
    meslo-lgs-nf

    #for benchmaking stuff
    hyperfine

    #replacements for common posix tools
    eza # ls replacement
    bat # pretty `cat` clone
    delta # viewer for `git` and `diff` output
    dust # pretty `du` version
    duf # better `df` clone
    gping # `ping`... but with a graph!!
    tldr # `man` but more straight-forward and simpler
    ripgrep # grep, but written in rust, respects .gitignore, and very very fast, command is `rg`

    #adds `sensors` command
    lm_sensors

    #for ebook reading
    foliate

    #rssfeed
    newsboat
    lynx

    #small nicities
    wl-clipboard # clipboard utils in wayland (wl-copy and wl-paste)
    libnotify # notifications library
    xdg-utils # xdg utils

    #HTML/CSS/JSON/ESLint language servers
    vscode-langservers-extracted

    #manage bluetooth devices
    blueman

    #audio mixer
    pwvucontrol

    #sets background, also works on niri :3
    swaybg

    just
    gamescope

    #minecraft
    prismlauncher

    mpv
    pfetch-rs
    mumble
    system76-keyboard-configurator
    waypipe
    sshfs
    mission-center
    handbrake
    nix-update
    htop
    bottom
    wget
    unzip
    mold
    compsize
    intel-gpu-tools
    killall
    gcc
    gnumake
    gparted

    #openstreetmap editor
    josm

    #nix formatter 
    nixfmt-rfc-style

    #see https://github.com/NixOS/nixpkgs/pull/315139/files#r1649579015
    # xdg-user-dirs
    inputs.finamp.legacyPackages.${pkgs.system}.finamp
  ];

  services.swayidle = {
    enable = true;
    package = pkgs.swayidle;
    events = [
      {
        event = "before-sleep";
        command = "${pkgs.swaylock}/bin/swaylock -fF";
      }
    ];
  };

  programs.librewolf = {
    enable = true;
    settings = {
      "webgl.disabled" = false;
      "privacy.resistFingerprinting" = false;
      "privacy.clearOnShutdown.history" = false;
      "privacy.clearOnShutdown.cookies" = false;
      "network.cookie.lifetimePolicy" = 0;
      "general.useragent.compatMode.firefox" = true;
      "identity.fxaccounts.enabled" = true;
      "services.sync.prefs.sync.privacy.clearOnShutdown.cookies" = false;
      "services.sync.prefs.sync.privacy.clearOnShutdown_v2.cookiesAndStorage" = false;

      "general.useragent.override" = "Mozilla/5.0 (X11; Linux x86_64; rv:126.0) Gecko/20100101 Firefox/126.0";

      "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";

      # For themeing
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      "browser.tabs.drawInTitlebar" = true;
      "svg.context-properties.content.enabled" = true;
    };
  };

  # Add Firefox GNOME theme directory
  home.file."firefox-mod-blur" = {
    target = ".librewolf/tckj7njq.default-release/chrome";
    source = (fetchTarball "https://github.com/datguypiko/Firefox-Mod-Blur/archive/master.tar.gz");
  };

  #common tools
  home.sessionVariables = {
    EDITOR = "hx";
    BROWSER = "librewolf";
    TERMINAL = "alacritty";
  };

  #bluetooth manager
  services.blueman-applet.enable = true;

  #dark mode
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  #notification daemon
  services.dunst = {
    enable = true;
    package = pkgs.dunst;
  };

  #feed reader
  programs.newsboat = {
    enable = true;
    #store rss feeds in a seperate file beacuse it's *a lot*
    urls = import ./progs/rss.nix;
  };

  #git (self explanatory)
  programs.git = {
    enable = true;
    package = pkgs.git;
    userName = "Simon Gardling";
    userEmail = "titaniumtown@proton.me";

    #better way to view diffs
    delta.enable = true;

    #master -> main
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
    };

    #gpg signing keys
    signing = {
      key = "9AB28AC10ECE533D";
      signByDefault = true;
    };
  };

  #fish shell!
  programs.fish = import ./progs/fish.nix { inherit pkgs; };

  #rofi for application launcher
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    theme = "solarized";
    font = "hack 15";
    extraConfig = {
      modi = "window,drun,ssh,combi";
      combi-modi = "window,drun,ssh";
    };
  };

  #waybar for status bar
  programs.waybar = import ./progs/waybar.nix;

  #allow extra fonts to be detected by fontconfig
  fonts.fontconfig.enable = true;

  nixpkgs.config.allowUnfree = true;

  programs.swaylock = {
    enable = true;
    settings = import ./progs/swaylock.nix;
  };

  #for trezor stuff
  /*
    trezor-udev-rules #trezor udev rules
    trezord
    trezor-suite
    monero-gui
    monero-cli
    trezorctl
  */

  #window manager
  programs.niri = {
    settings = import ./progs/niri.nix { inherit config; };
  };

  #Terminal emulator
  programs.alacritty = {
    enable = true;
    package = pkgs.alacritty;
    settings = import ./progs/alacritty.nix;
  };

  #backup utility
  programs.borgmatic = {
    enable = true;
    package = pkgs.borgmatic;
    backups = import ./progs/borg.nix;
  };

  #text editor
  programs.helix = import ./progs/helix.nix { inherit pkgs; };

  #gtk application theming
  gtk = {
    enable = true;
    # make gtk3 applications look like libadwaita applications!
    theme = {
      package = pkgs.adw-gtk3;
      name = "adw-gtk3-dark";
    };
    iconTheme = {
      package = pkgs.gnome.adwaita-icon-theme;
      name = "Adwaita";
    };
  };

  #qt application theming
  qt = {
    enable = true;
    style = {
      name = "adwaita-dark";
    };
  };

  #macOS cursor!
  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.apple-cursor;
    name = "macOS-Monterey";
    size = 24;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
