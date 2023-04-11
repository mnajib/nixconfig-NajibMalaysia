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
  boot.supportedFilesystems =          [ "btrfs" "ext4" "xfs" "vfat" "zfs" ]; #"zfs" "bcachefs"

  boot.initrd = {
    availableKernelModules = [ "ehci_pci" "ahci" "xhci_pci" "ata_piix" "usbhid" "usb_storage" "sd_mod" ];
    kernelModules =          [ "btrfs" "ext4" "xfs" "vfat" "dm-crypt" "dm-snapshot" "dm-raid" "zfs" ]; #"zfs" "bcachefs"
    supportedFilesystems =   [ "btrfs" "ext4" "xfs" "vfat" "dm-crypt" "dm-snapshot" "dm-raid" "zfs" ]; #"zfs" "bcachefs"

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

    #luks.devices."crypt-d47246ca-80af-4cef-b098-29785152ce44" = { device = "/dev/disk/by-uuid/d47246ca-80af-4cef-b098-29785152ce44"; };

    #------------------
    # For OS (nixos)
    #------------------

    # AGI SSD 256GB
    luks.devices."luks-bcd7371c-c49a-4b74-a041-9cf9728cf395" = { device = "/dev/disk/by-uuid/bcd7371c-c49a-4b74-a041-9cf9728cf395"; preLVM = true; };   # xfs (nixos)
    luks.devices."luks-781bbff1-508d-4287-a748-63d45d74b5e5" = { device = "/dev/disk/by-uuid/781bbff1-508d-4287-a748-63d45d74b5e5"; preLVM = true; };   # swap

    #------------------
    # For data storage (zfs pool)
    #------------------

    luks.devices."luks-8a53d158-ba69-47a1-9329-2d07372949d6" = { device = "/dev/disk/by-uuid/8a53d158-ba69-47a1-9329-2d07372949d6"; };                  # 500GB.
    #luks.devices."luks-8eee41a6-35ba-4a1e-ae58-b18446505fd4" = { device = "/dev/disk/by-uuid/8eee41a6-35ba-4a1e-ae58-b18446505fd4"; };                 # 500GB. Seagate. This harddisk is failling; replaced with below harddisk.
    luks.devices."luks-18b00c41-f401-439a-b3dd-a77b94e9324e" = { device = "/dev/disk/by-uuid/18b00c41-f401-439a-b3dd-a77b94e9324e"; };                  # 500GB. Toshiba. This harddisk was taken from maryam (a laptop name).

    luks.devices."luks-912c3919-4dec-4298-bac9-e3636ef32bfd" = { device = "/dev/disk/by-uuid/912c3919-4dec-4298-bac9-e3636ef32bfd"; };                  # 500GB.
    luks.devices."luks-9a965e58-3780-475a-8325-6f47c669cc1d" = { device = "/dev/disk/by-uuid/9a965e58-3780-475a-8325-6f47c669cc1d"; };                  # 500GB.

    luks.devices."luks-ec2dca2b-84e7-4d33-b6fd-7bdad06ec445" = { device = "/dev/disk/by-uuid/ec2dca2b-84e7-4d33-b6fd-7bdad06ec445"; };                  # 1TB, bought used-hdd from Shopee on 2023-04.
    luks.devices."luks-acfbbc38-c2c4-453f-b995-f02f8cf17bac" = { device = "/dev/disk/by-uuid/acfbbc38-c2c4-453f-b995-f02f8cf17bac"; };                  # 1TB, bought used-hdd from Shopee on 2023-04.
  };

  fileSystems."/" = {
    #device = "/dev/mapper/crypt-d47246ca-80af-4cef-b098-29785152ce44";
    #fsType = "btrfs";
    #options = [
    #  "subvol=nixos"
    #  "compress=zstd" "noatime" "autodefrag"
    #];

    device = "/dev/disk/by-uuid/a64b6850-5e88-4cc3-b106-28a724c4b2cc";
    fsType = "xfs";
  };

  fileSystems."/boot" = { device = "/dev/disk/by-uuid/bdccf3bb-061c-40d5-82c3-d04ccf603485";
    fsType = "ext4";
  };

  fileSystems."/home" = {
    device = "najibzfspool1/home";
    fsType = "zfs";
  };

  fileSystems."/root" = {
    #device = "/dev/mapper/crypt-d47246ca-80af-4cef-b098-29785152ce44";
    #fsType = "btrfs";
    #options = [
    #  "subvol=root"
    #  "compress=zstd" "noatime" "autodefrag"
    #];

    device = "najibzfspool1/root";
    fsType = "zfs";
  };

  #fileSystems."/nix" =
  #  {
  #    device = "/dev/mapper/crypt-d47246ca-80af-4cef-b098-29785152ce44";
  #    fsType = "btrfs";
  #    options = [
  #      "subvol=nix"
  #      "compress=zstd" "noatime" "autodefrag"
  #    ];
  #  };

  #fileSystems."/home/data" =
  #  { device = "/dev/disk/by-uuid/873d4891-8d71-4e7a-975d-84d8342559c2";
  #    fsType = "btrfs";
  #    options = [
  #      "subvol=data"
  #      "compress=zstd" "noatime" "autodefrag"
  #    ];
  #  };

  #fileSystems."/home" = {
  #    device = "/dev/mapper/crypt-d47246ca-80af-4cef-b098-29785152ce44";
  #    fsType = "btrfs";
  #    options = [
  #      "subvol=home"
  #      "compress=zstd" "noatime" "autodefrag"
  #    ];
  #};

  #fileSystems."/home/najib" =
  #  {
  #    #device = "/dev/disk/by-uuid/873d4891-8d71-4e7a-975d-84d8342559c2";
  #    device = "/dev/mapper/crypt-d47246ca-80af-4cef-b098-29785152ce44";
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

  #fileSystems."/boot" = {
  #  #device = "/dev/disk/by-uuid/7e9237ab-5825-42b5-b105-61aad181545e";
  #  #device = "/dev/disk/by-uuid/52794df2-a415-4dba-8203-949381c5c00a"; # boot partition on 254GB SSD
  #  device = "/dev/disk/by-uuid/52794df2-a415-4dba-8203-949381c5c00a";
  #    fsType = "ext4";
  #};

  # This HDD is failing
  #fileSystems."/boot2" = {
  #    device = "/dev/disk/by-uuid/7e9237ab-5825-42b5-b105-61aad181545e";
  #    fsType = "ext4";
  #};

  #fileSystems."/swap" = {
  #  device = "/dev/mapper/crypt-d47246ca-80af-4cef-b098-29785152ce44";
  #  fsType = "btrfs";
  #  options = [
  #    "subvol=swap"
  #    "noatime"
  #  ];
  #};

  swapDevices =  [
    # This HDD is failing
    #{ device = "/dev/disk/by-uuid/54a11355-d334-46c5-8cbb-43369d08fd8a"; } # swap on 500GB HDD

    #{ device = "/dev/disk/by-uuid/600ebd52-edd2-4c42-b3b1-b8d8a6cb5acf"; } # swap partition on 254GB SSD

    #{
    #  device = "/swap/swapfile";
    #  #priority = 0;
    #  size = (1024 * 12) * 2;
    #}

    #{ device = "/dev/disk/by-uuid/79d45678-d31b-4b39-851b-f00559ea8cc6"; }
    { device = "/dev/disk/by-uuid/79d45678-d31b-4b39-851b-f00559ea8cc6"; }
  ];

  networking.useDHCP = lib.mkDefault true;
  #networking.interfaces.enp5s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform.system = "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
