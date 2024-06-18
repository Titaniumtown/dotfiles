{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [
    #if this is removed, then niri doesn't start, TODO! look into wtf this does
    (modulesPath + "/installer/scan/not-detected.nix")
  ];
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "thunderbolt"
    "nvme"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/acbd96e3-e7c7-442d-82cc-ce2913a9e90c";
    fsType = "btrfs";
    options = [
      "subvol=@"
      "compress=zstd"
      "autodefrag"
      "noatime"
      "space_cache=v2"
      "discard"
    ];
  };

  boot.initrd.luks.devices."luks-0f481d5f-528c-4838-bd8a-d2780b4ba234".device = "/dev/disk/by-uuid/0f481d5f-528c-4838-bd8a-d2780b4ba234";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/4D19-520E";
    fsType = "vfat";
  };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp166s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
