{ pkgs, config, ... }:
{
    #boot.loader.grub.enable = true;
    #boot.loader.grub.version = 2;
    #boot.loader.grub.device = "nodev";
    boot.loader.grub.efiSupport = true;
    #boot.loader.grub.useOSProber = true;

    #mirroredBoots = [
    #    {
    #        devices = [ "nodev" ];
    #        path = "/boot";
    #    }
    #    {
    #        devices = [ "nodev" ];
    #        path = "/boot2";
    #    }
    #];

    # For zfs
    #zfsSupport = true;
    #copyKernels = true;

    boot.loader.systemd-boot.enable = true;

    boot.loader.efi.canTouchEfiVariables = true; # Must be disabled if efiInstallAsRemovable=true ?

    #boot.loader.efi.efiSysMountPoint = "/boot/efi";
    #boot.loader.efi.efiSysMountPoint = "/boot"; # Default

    #boot.loader.grub.efiInstallAsRemovable = true;
}
