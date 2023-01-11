# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "uhci_hcd" "ehci_pci" "ata_piix" "ahci" "firewire_ohci" "usb_storage" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/c2954c64-4b33-4402-b65b-034aa6f3649a";
      fsType = "btrfs";
      options = [ "subvol=nixos" ];
    };

  boot.initrd.luks.devices."nixenc".device = "/dev/disk/by-uuid/1bc1c720-538d-40f1-8a0d-13edf4841c89";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/19b3b34d-18b4-461a-919e-3eb3881945a0";
      fsType = "ext4";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/e672794e-8f63-439e-9654-f689e2a1e67c"; }
    ];

  #networking.enableRedistributableFirmware = true;
  hardware.enableAllFirmware = true;
}