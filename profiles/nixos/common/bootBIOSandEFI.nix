# modules/bootBIOSandEFI.nix
#universal-boot
{ config, pkgs, lib, ... }:

{
  options.universalBoot.enable = lib.mkEnableOption "Enable universal BIOS+EFI bootloader setup";

  config = lib.mkIf config.universalBoot.enable {
    boot.loader.grub = {
      enable = true;
      #version = 2;                  # This option does not have any effect anymore
      device = "nodev";              # works across machines
      efiSupport = true;             # install GRUB EFI
      efiInstallAsRemovable = true;  # more portable for EFI firmware
      copyKernels = true;
    };

    # Ensure ESP is mounted at /boot
    #fileSystems."/boot" = lib.mkDefault {
    #  device = "/dev/disk/by-partlabel/ESP";
    #  fsType = "vfat";
    #};

    boot.supportedFilesystems = [ "vfat" "ext4" ];

    # Make initrd portable across hardware
    boot.initrd.availableKernelModules = [
      "ahci" "xhci_pci" "ehci_pci" "usb_storage" "usbhid"
    ];
  };
}

