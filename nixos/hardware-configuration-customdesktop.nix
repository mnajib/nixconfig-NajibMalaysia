# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.kernelModules =                 [ "kvm-intel" ];
  boot.extraModulePackages =           [ ];
  boot.supportedFilesystems =          [ "btrfs" "ext4" "xfs" "vfat" ]; #"zfs" "bcachefs"

  boot.initrd = {
    availableKernelModules = [ "ehci_pci" "ahci" "xhci_pci" "ata_piix" "usbhid" "usb_storage" "sd_mod" ];
    kernelModules =          [ "btrfs" "ext4" "xfs" "vfat" "dm-crypt" "dm-snapshot" "dm-raid" ]; #"zfs" "bcachefs"
    supportedFilesystems =   [ "btrfs" "ext4" "xfs" "vfat" "dm-crypt" "dm-snapshot" "dm-raid" ]; #"zfs" "bcachefs"

    # /dev/sda2 --> LUKS --> LVM --> btrfs
    # /dev/sdb2 --> LUKS --> LVM --> btrfs
    # lsblk
    # blkid /dev/sdb2
    # blkid /dev/sda2

    #luks.devices."crypt1" = {
    #  device = "/dev/disk/by-uuid/552eb401-53a0-43d2-9782-26d28796b6a0"; # /dev/sdb2; 2nd partition on 254GB SSD?
    #  preLVM = true;
    #};

    # This HDD is failing
    #luks.devices."crypt2" = {
    #  device = "/dev/disk/by-uuid/b382a40d-a780-4eb3-835e-f064039af496"; #/dev/sda2; 2nd partition on 500GB HDD?
    #  preLVM = true;
    #};

    luks.devices."crypt-sda2" = {
      device = "/dev/disk/by-uuid/d47246ca-80af-4cef-b098-29785152ce44";
    };
  };

  fileSystems."/" = {
    #device = "/dev/disk/by-uuid/873d4891-8d71-4e7a-975d-84d8342559c2";
    device = "/dev/mapper/crypt-sda2";
    fsType = "btrfs";
    options = [
      "subvol=nixos"
      "compress=zstd" "noatime" "autodefrag"
    ];
  };

  fileSystems."/root" =
    {
      #device = "/dev/disk/by-uuid/873d4891-8d71-4e7a-975d-84d8342559c2";
      device = "/dev/mapper/crypt-sda2";
      fsType = "btrfs";
      options = [
        "subvol=root"
        "compress=zstd" "noatime" "autodefrag"
      ];
    };

  fileSystems."/nix" =
    {
      device = "/dev/mapper/crypt-sda2";
      fsType = "btrfs";
      options = [
        "subvol=nix"
        "compress=zstd" "noatime" "autodefrag"
      ];
    };

  fileSystems."/swap" =
    {
      device = "/dev/mapper/crypt-sda2";
      fsType = "btrfs";
      options = [
        "subvol=swap"
        "noatime"
      ];
    };

  #fileSystems."/home/data" =
  #  { device = "/dev/disk/by-uuid/873d4891-8d71-4e7a-975d-84d8342559c2";
  #    fsType = "btrfs";
  #    options = [
  #      "subvol=data"
  #      "compress=zstd" "noatime" "autodefrag"
  #    ];
  #  };

  fileSystems."/home" = {
      device = "/dev/mapper/crypt-sda2";
      fsType = "btrfs";
      options = [
        "subvol=home"
        "compress=zstd" "noatime" "autodefrag"
      ];
  };

  #fileSystems."/home/najib" =
  #  {
  #    #device = "/dev/disk/by-uuid/873d4891-8d71-4e7a-975d-84d8342559c2";
  #    device = "/dev/mapper/crypt-sda2";
  #    fsType = "btrfs";
  #    options = [
  #      "subvol=najib"
  #      "compress=zstd" "noatime" "autodefrag"
  #    ];
  #  };

  #fileSystems."/home/julia" =
  #  { device = "/dev/disk/by-uuid/873d4891-8d71-4e7a-975d-84d8342559c2";
  #    fsType = "btrfs";
  #    options = [
  #      "subvol=julia"
  #      "compress=zstd" "noatime" "autodefrag"
  #    ];
  #  };

  #fileSystems."/home/naqib" =
  #  { device = "/dev/disk/by-uuid/873d4891-8d71-4e7a-975d-84d8342559c2";
  #    fsType = "btrfs";
  #    options = [
  #      "subvol=naqib"
  #      "compress=zstd" "noatime" "autodefrag"
  #    ];
  #  };

  #fileSystems."/home/nurnasuha" =
  #  { device = "/dev/disk/by-uuid/873d4891-8d71-4e7a-975d-84d8342559c2";
  #    fsType = "btrfs";
  #    options = [
  #      "subvol=nurnasuha"
  #      "compress=zstd" "noatime" "autodefrag"
  #    ];
  #  };

  #fileSystems."/home/naim" =
  #  {
  #    device = "/dev/disk/by-uuid/873d4891-8d71-4e7a-975d-84d8342559c2";
  #    fsType = "btrfs";
  #    options = [
  #      "subvol=naim"
  #      "compress=zstd" "noatime" "autodefrag"
  #    ];
  #  };

  # Move to/etc/nixos/btrbk-pull.nix.
  #fileSystems."/mnt/btrbk_pool" = #"/mnt2" =
  #  {
  #    #device = "/dev/disk/by-uuid/37501eaa-13b2-44ac-a8d8-4e62b7803cd5";
  #    device = "/dev/mapper/lvmvg1-lvmlvroot1";
  #    fsType = "btrfs";
  #    options = ["subvolid=5"
  #      "compress=zstd" "noatime" "autodefrag"
  #    ];
  #  };

  fileSystems."/boot" =
    {
      #device = "/dev/disk/by-uuid/7e9237ab-5825-42b5-b105-61aad181545e";
      #device = "/dev/disk/by-uuid/52794df2-a415-4dba-8203-949381c5c00a"; # boot partition on 254GB SSD
      device = "/dev/disk/by-uuid/52794df2-a415-4dba-8203-949381c5c00a";
      fsType = "ext4";
    };

  # This HDD is failing
  #fileSystems."/boot2" =
  #{
  #    device = "/dev/disk/by-uuid/7e9237ab-5825-42b5-b105-61aad181545e";
  #    fsType = "ext4";
  #};

  swapDevices = [
    # This HDD is failing
    #{ device = "/dev/disk/by-uuid/54a11355-d334-46c5-8cbb-43369d08fd8a"; } # swap on 500GB HDD

    #{ device = "/dev/disk/by-uuid/600ebd52-edd2-4c42-b3b1-b8d8a6cb5acf"; } # swap partition on 254GB SSD

    {
      device = "/swap/swapfile";
      #priority = 0;
      size = (1024 * 12) * 2;
    }
  ];

  networking.useDHCP = lib.mkDefault true;
  #networking.interfaces.enp5s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform.system = "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
