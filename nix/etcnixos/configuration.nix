{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hardware.nix
    ./declarative-nm.nix
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
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      # "mitigations=off"

      # "quiet"

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

    #use zstd level 19 (highest without `--ultra`) for the initrd
    initrd = {
      compressor = "zstd";
      compressorArgs = ["-19"];
    };
  };

  # auto mount usb drives i think (https://unix.stackexchange.com/questions/655158/automount-removable-media-using-udev-in-nixos)
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEMS=="usb", SUBSYSTEM=="block", ENV{ID_FS_USAGE}=="filesystem", RUN{program}+="${pkgs.systemd}/bin/systemd-mount --no-block --automount=yes --collect $devnode /media"
  '';

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

  # services.resolved.enable = false;

  #networking
  networking = import ./networking.nix;

  # Set your time zone.
  # time.timeZone = "America/New_York";
  services.automatic-timezoned.enable = true;

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
    };
  };

  # Enable common container config files in /etc/containers
  virtualisation.containers.enable = true;
  virtualisation = {
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
    libva-utils

    #mullvad
    mullvad-vpn
    home-manager

    distrobox
    niri
    swaylock
  ];

  #weird hack to get swaylock working? idk, if you don't put this here, password entry doesnt work
  #if I move to another lock screen program, i will have to replace `swaylock`
  security.pam.services.swaylock = {};

  system.stateVersion = "24.11";
}
