{
  config,
  pkgs,
  inputs,
  ...
}: {
  home.username = "primary";
  home.homeDirectory = "/home/primary";

  home.stateVersion = "23.11";

  home.packages = with pkgs; [
    firefox

    gnome.gnome-calculator #calculator
    gnome-text-editor #text editor
    gnome.nautilus #file manager
    gnome.eog #image viewer

    helix
    hexyl #hex viewer

    #productivity stuff
    libreoffice
    hunspell #auto correct
    hunspellDicts.en_US

    #rust stuff
    rustc
    rustfmt
    cargo
    rust-analyzer

    #locallm inference
    gpt4all

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

    #java 17 because last time we used a newer version, stuff for school broke
    openjdk17

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
    nerdfonts #🤓
    jetbrains-mono
    meslo-lgs-nf

    #shell and common tools
    nix-update
    htop
    bottom

    #misc cli utils
    wget
    unzip

    #compiling stuff
    mold

    #used for measuring compression ratios
    compsize

    hyperfine #for benchmaking stuff

    #replacements for common posix tools
    eza #ls replacement
    bat #pretty `cat` clone
    delta #viewer for `git` and `diff` output
    dust #pretty `du` version
    duf #better `df` clone
    gping #`ping`... but with a graph!!
    tldr #`man` but more straight-forward and simpler
    ripgrep #grep, but written in rust, respects .gitignore, and very very fast, command is `rg`

    #adds `sensors` command
    lm_sensors

    #for ebook reading
    foliate

    #rssfeed
    newsboat
    lynx

    #nix style checker
    alejandra

    #small nicities
    wl-clipboard #clipboard utils in wayland (wl-copy and wl-paste)
    libnotify #notifications library
    xdg-utils #xdg utils

    #HTML/CSS/JSON/ESLint language servers
    vscode-langservers-extracted

    #window manager
    niri

    #manage bluetooth devices
    blueman

    intel-gpu-tools
    killall

    gcc
    gnumake
    gparted

    #audio mixer
    pavucontrol

    #sets background, also works on niri :3
    swaybg

    just

    gamescope

    #minecraft
    prismlauncher

    pfetch-rs

    powerstat

    mumble

    # chromium

    #I want to move to this in the future
    # librewolf
  ];
  /*
  ++ [
    (pkgs.python3.withPackages (python-pkgs: [
      # python-pkgs.selenium
      # python-pkgs.selenium-wire
      python-pkgs.requests
      python-pkgs.pandas
      python-pkgs.numpy
      python-pkgs.setuptools
      python-pkgs.psutil
      python-pkgs.blinker
      python-pkgs.apprise
      python-pkgs.pyyaml
      python-pkgs.websockets
      nur.repos.milahu.python3Packages.selenium-driverless
      nur.repos.milahu.python3Packages.cdp-socket
    ]))
  ];
  */
  /*
    programs.librewolf = {
    enable = true;
    # Enable WebGL, cookies and history
    settings = {
      "webgl.disabled" = false;
      "privacy.resistFingerprinting" = false;
      "privacy.clearOnShutdown.history" = false;
      "privacy.clearOnShutdown.cookies" = false;
      "network.cookie.lifetimePolicy" = 0;
      "identity.fxaccounts.enabled" = true;
    };
  };
  */

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
    browser = "firefox";
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
  programs.fish = import ./progs/fish.nix {inherit pkgs;};

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
    package = pkgs.niri;
    settings = import ./progs/niri.nix {inherit config;};
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
  programs.helix = import ./progs/helix.nix {inherit pkgs;};

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

  #set what i use
  home.sessionVariables = {
    EDITOR = "hx";
    BROWSER = "firefox";
    TERMINAL = "alacritty";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
