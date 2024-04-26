{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hardware.nix
  ];

  #enable flakes!
  nix.settings.experimental-features = ["nix-command" "flakes"];

  nix = {
    #garbage collection and cleanup stuff
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    #optimize the store
    optimise.automatic = true;
  };

  #kernel options
  boot = {
    kernelPackages = pkgs.linuxPackages_cachyos-lto;
    kernelParams = [
      "mitigations=off"

      # For Power consumption
      # https://kvark.github.io/linux/framework/2021/10/17/framework-nixos.html
      "mem_sleep_default=deep"
      # Workaround iGPU hangs
      # https://discourse.nixos.org/t/intel-12th-gen-igpu-freezes/21768/4
      "i915.enable_psr=1"
    ];

    blacklistedKernelModules = [
      # This enables the brightness and airplane mode keys to work
      # https://community.frame.work/t/12th-gen-not-sending-xf86monbrightnessup-down/20605/11
      "hid-sensor-hub"
      # This fixes controller crashes during sleep
      # https://community.frame.work/t/tracking-fn-key-stops-working-on-popos-after-a-while/21208/32
      "cros_ec_lpcs"
    ];

    kernel.sysctl = {
      #for profiling
      "kernel.perf_event_paranoid" = 1;
      "kernel.kptr_restrict" = 0;
    };

    # Bootloader.
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    enableContainers = false;
  };

  #fwupd for updating firmware
  services.fwupd = {
    enable = true;
    extraRemotes = ["lvfs-testing"];
  };

  #lets use doas and not sudo!
  security.doas.enable = true;
  security.sudo.enable = false;
  # Configure doas
  security.doas.extraRules = [
    {
      users = ["primary"];
      keepEnv = true;
      persist = true;
    }
  ];

  #disable fprintd (doesn't compile, idk)
  services.fprintd.enable = false;

  #using btrfs, so lets scrub!
  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
    fileSystems = ["/"];
  };

  #Making sure mullvad works on boot
  services.mullvad-vpn.enable = true;
  services.resolved.enable = true;

  #networking
  networking = {
    hostName = "framework";
    wireless = {
      enable = true;
      #import network creds from a seperate config (for .gitignore perchance)
      networks = import ./wifi-creds.nix;

      #allow wpa_supplicant to be changed by the user
      userControlled = {
        enable = true;
      };
    };
  };

  # Set your time zone.
  time.timeZone = "America/New_York";

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

  services.xserver.excludePackages = with pkgs; [xterm];

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

  #drivers
  hardware.opengl.extraPackages = with pkgs; [
    mesa_drivers
    vaapiIntel
    vaapiVdpau
    libvdpau-va-gl
    intel-media-driver
    intel-compute-runtime #compute stuff
  ];

  hardware.opengl = {
    enable = true;
    driSupport = true;
  };

  #apply gtk themes by enabling dconf
  programs.dconf.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;
  #auto detect network printers
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  services.printing.drivers = with pkgs; [hplip];

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false; #pipewire >>>>>>> pulseaudio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  nix.settings.trusted-users = ["primary"];
  # Define my user account (the rest of the configuration if found in `./home.nix`)
  users.users.primary = {
    isNormalUser = true;
    extraGroups = ["networkmanager" "wheel" "video"];
  };

  # Enable thermal data
  services.thermald.enable = true;

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
      CPU_MAX_PERF_ON_BAT = 30;
    };
  };

  #System packages
  environment.systemPackages = with pkgs; [
    libva-utils

    #mullvad
    mullvad-vpn
    home-manager

    # linuxPackages_cachyos-lto.perf
  ];

  system.stateVersion = "24.05";
}