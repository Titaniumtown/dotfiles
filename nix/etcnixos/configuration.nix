{
  config,
  pkgs,
  lib,
  username,
  ...
}:
{
  imports = [
    ./hardware.nix
    ./declarative-nm.nix
  ];

  nix = {
    #garbage collection and cleanup stuff
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    #optimize the store
    optimise.automatic = true;

    #enable flakes!
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  #kernel options
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };

    kernel.sysctl = {
      #for profiling
      "kernel.perf_event_paranoid" = 1;
      "kernel.kptr_restrict" = 0;

      #dmesg shushhhhh
      "kernel.printk" = "2 4 1 7";
    };

    # Bootloader.
    loader = {

      /*
        Lanzaboote currently replaces the systemd-boot module.
        This setting is usually set to true in configuration.nix
        generated at installation time. So we force it to false
        for now.
      */
      systemd-boot.enable = lib.mkForce false;

      efi.canTouchEfiVariables = true;
    };

    enableContainers = false;

    #use zstd level 19 (highest without `--ultra`) for the initrd
    initrd = {
      compressor = "zstd";
      compressorArgs = [ "-19" ];
    };
  };

  environment.etc = {
    "issue" = {
      text = "";
    };
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd ${pkgs.niri}/bin/niri-session";
        user = "${username}";
      };
    };
  };

  # this is a life saver.
  # literally no documentation about this anywhere.
  # might be good to write about this...
  # https://www.reddit.com/r/NixOS/comments/u0cdpi/tuigreet_with_xmonad_how/
  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal"; # Without this errors will spam on screen
    # Without these bootlogs will spam on screen
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };

  services = {
    # auto mount usb drives i think (https://unix.stackexchange.com/questions/655158/automount-removable-media-using-udev-in-nixos)
    udev.extraRules = ''
      ACTION=="add", SUBSYSTEMS=="usb", SUBSYSTEM=="block", ENV{ID_FS_USAGE}=="filesystem", RUN{program}+="${pkgs.systemd}/bin/systemd-mount --no-block --automount=yes --collect $devnode /media"
    '';

    #fwupd for updating firmware
    fwupd = {
      enable = true;
      extraRemotes = [ "lvfs-testing" ];
    };

    # Enable CUPS to print documents.
    printing.enable = true;

    #auto detect network printers
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    printing.drivers = with pkgs; [ hplip ];

    #disable fprintd (doesn't compile, idk)
    fprintd.enable = false;

    #using btrfs, so lets scrub!
    btrfs.autoScrub = {
      enable = true;
      interval = "weekly";
      fileSystems = [ "/" ];
    };

    #Making sure mullvad works on boot
    mullvad-vpn.enable = true;

    # Set your time zone.
    # time.timeZone = "America/New_York";
    automatic-timezoned.enable = true;
  };

  security = {
    #lets use doas and not sudo!
    doas.enable = true;
    sudo.enable = false;
    # Configure doas
    doas.extraRules = [
      {
        users = [ "${username}" ];
        keepEnv = true;
        persist = true;
      }
    ];
  };

  #networking
  networking = import ./networking.nix;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  #wayland with electron/chromium applications
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Enable Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;

    settings = {
      #Enable experimental features for battery % of bluetooth devices
      General = {
        Experimental = true;
      };
    };
  };

  #apply gtk themes by enabling dconf
  programs.dconf.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false; # pipewire >>>>>>> pulseaudio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  nix.settings.trusted-users = [ "${username}" ];
  # Define my user account (the rest of the configuration if found in `~/.config/home-manager/...`)
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
    ];
  };

  # Enable thermal data
  services.thermald.enable = true;

  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-curses;
    enableSSHSupport = true;
  };

  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 60;

      CPU_BOOST_ON_BAT = 0;
      START_CHARGE_THRESH_BAT0 = 90;
      STOP_CHARGE_THRESH_BAT0 = 97;
      RUNTIME_PM_ON_BAT = "auto";
    };
  };

  # Enable common container config files in /etc/containers
  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  #System packages
  environment.systemPackages = with pkgs; [
    mullvad-vpn
    home-manager

    distrobox
    niri
    swaylock

    #secureboot ctl
    sbctl
  ];

  #weird hack to get swaylock working? idk, if you don't put this here, password entry doesnt work
  #if I move to another lock screen program, i will have to replace `swaylock`
  security.pam.services.swaylock = { };

  system.stateVersion = "24.11";
}
