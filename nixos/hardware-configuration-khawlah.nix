# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
    imports = [
      (modulesPath + "/installer/scan/not-detected.nix")

      ./hardware-khawlah-storage.nix
      #./hardware-khawlah-machine.nix
    ];

    #boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usb_storage" "sd_mod" "sdhci_pci" ];
    #boot.initrd.kernelModules =        [ "btrfs" "ext4" "xfs" "vfat" "dm-crypt" "dm-snapshot" "dm-raid" ]; #"zfs" "bcachefs"
    #boot.initrd.supportedFilesystems = [ "btrfs" "ext4" "xfs" "vfat" "dm-crypt" "dm-snapshot" "dm-raid" ]; #"zfs"

    #boot.kernelModules = [ "kvm-intel" ];
    #boot.extraModulePackages = [ ];

    #boot.initrd.luks.devices."khawlahNixos".device = "/dev/disk/by-uuid/355fbcfc-e425-4ee5-9337-6f88d0894e3c";

    #swapDevices =
    #  [
    #      { device = "/dev/disk/by-uuid/d103b089-590a-4b31-a76f-335043ea4ca5"; }
    #      { device = "/dev/disk/by-uuid/601b18ee-60df-4e3e-b086-e41becd0c5b6"; }
    #  ];

    powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

    nixpkgs.hostPlatform.system = "x86_64-linux";
    nix.settings.max-jobs = lib.mkDefault 2;                           # 3; 4;
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
